Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751755AbaCFHAz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 02:00:55 -0500
Received: from mail-ee0-f48.google.com ([74.125.83.48]:50202 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790AbaCFHAy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 02:00:54 -0500
Date: Thu, 6 Mar 2014 09:00:47 +0200
From: Muli Ben-Yehuda <muli@cs.technion.ac.il>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: WANG Chao <chaowang@redhat.com>, "Jon D. Mason" <jdmason@kudzu.us>,
        Thomas Gleixner <tglx@linutronix.de>, Vivek Goyal <vgoyal@redhat.com>,
        Yinghai Lu <yinghai@kernel.org>, Baoquan He <bhe@redhat.com>,
        kexec@lists.infradead.org, discuss@x86-64.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: How could we get rid of saved_max_pfn for calgary iommu?
Message-ID: <20140306070047.GF16859@needle.mulix.org>
References: <20140219061824.GA29703@dhcp-17-89.nay.redhat.com>
 <20140305053617.GE26240@dhcp-17-89.nay.redhat.com>
 <20140306064756.GB16859@needle.mulix.org>
 <53181AC1.2020807@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53181AC1.2020807@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 05, 2014 at 10:50:41PM -0800, H. Peter Anvin wrote:

> OK, second question... is it time to axe Calgary?

I don't know of anyone still using it, but it's not
impossible. Calgary and CalIOC2 machines would now be ~5-8 years old.

Cheers,
Muli
