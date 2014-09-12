Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752356AbaILQC5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 12:02:57 -0400
Received: from borg.tf-network.de ([62.75.218.204]:47256 "EHLO
	borg.tf-network.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751780AbaILQCz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 12:02:55 -0400
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Fri, 12 Sep 2014 12:02:55 EDT
Message-ID: <5413179C.8020902@whissi.de>
Date: Fri, 12 Sep 2014 17:56:12 +0200
From: "Thomas D." <whissi@whissi.de>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>, Baoquan He <bhe@redhat.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "ebiederm@xmission.com" <ebiederm@xmission.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "kumagai-atsushi@mxc.nes.nec.co.jp" 
	<kumagai-atsushi@mxc.nes.nec.co.jp>
Subject: Re: [Patch v3 1/2] kaslr: check if kernel location is changed
References: <1410502832-3573-1-git-send-email-bhe@redhat.com> <20140912152244.GA2781@dhcp-16-105.nay.redhat.com> <20140912153308.GB4408@redhat.com>
In-Reply-To: <20140912153308.GB4408@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Vivek Goyal wrote:
> You had reported kexec issues with CONFIG_RANDOMIZE_BASE=y. Does this
> patch resolve the issue for you?

Yup! Tested against kernel-3.16.2.


-Thomas

