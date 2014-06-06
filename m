Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752509AbaFFVCm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 17:02:42 -0400
Received: from mail-qg0-f44.google.com ([209.85.192.44]:38926 "EHLO
	mail-qg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752174AbaFFVCl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 17:02:41 -0400
MIME-Version: 1.0
In-Reply-To: <53922C01.4040800@zytor.com>
References: <1401800822-27425-1-git-send-email-vgoyal@redhat.com>
	<20140603131203.GA23395@redhat.com>
	<20140605083134.GE3506@darkstar.nay.redhat.com>
	<20140605150159.GA14083@redhat.com>
	<20140606073748.GC3343@darkstar.nay.redhat.com>
	<53922686.6010301@zytor.com>
	<CAL01qpsf_-Ae_P-mfmqfu6DYavcb866YUnE4XM_7vdhfcAvMGg@mail.gmail.com>
	<53922C01.4040800@zytor.com>
Date: Fri, 6 Jun 2014 22:02:40 +0100
Message-ID: <CAL01qpu4P0+_yNoBekcpohuSv+n=u=a8sEnBMhfi7DzDRiiEfQ@mail.gmail.com>
Subject: Re: [RFC PATCH 00/13][V3] kexec: A new system call to allow in kernel loading
From: Matt Fleming <matt.fleming@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Dave Young <dyoung@redhat.com>, Vivek Goyal <vgoyal@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kexec@lists.infradead.org, ebiederm@xmission.com,
        "mjg59@srcf.ucam.org" <mjg59@srcf.ucam.org>, greg@kroah.com,
        "bp@alien8.de" <bp@alien8.de>, "jkosina@suse.cz" <jkosina@suse.cz>,
        chaowang@redhat.com, bhe@redhat.com,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6 June 2014 22:00, H. Peter Anvin <hpa@zytor.com> wrote:
>
> Yes, presumably (as a separate patch since the actual commit is quite
> large.)  The patch needs to have a good description why the original
> patch was wrong.

Right. I'll take a look at this in the morning.
