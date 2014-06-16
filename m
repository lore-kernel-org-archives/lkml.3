Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932235AbaFPTA7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 15:00:59 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52263 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755720AbaFPTA5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 15:00:57 -0400
Message-ID: <539F3E98.4040804@zytor.com>
Date: Mon, 16 Jun 2014 11:59:36 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Juergen Gross <jgross@suse.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Daniel Kiper <daniel.kiper@oracle.com>
CC: mjg59@srcf.ucam.org, jeremy@goop.org, linux-efi@vger.kernel.org,
        ian.campbell@citrix.com, andrew.cooper3@citrix.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, matt.fleming@intel.com,
        tglx@linutronix.de, david.vrabel@citrix.com, jbeulich@suse.com,
        xen-devel@lists.xenproject.org, boris.ostrovsky@oracle.com,
        mingo@redhat.com, eshelton@pobox.com
Subject: Re: [Xen-devel] [PATCH v5 7/7] arch/x86: Comment out efi_set_rtc_mmss()
References: <1402678823-24589-1-git-send-email-daniel.kiper@oracle.com>	<1402678823-24589-8-git-send-email-daniel.kiper@oracle.com> <alpine.DEB.2.02.1406161242050.13771@kaball.uk.xensource.com> <539EDAE9.7000605@suse.com>
In-Reply-To: <539EDAE9.7000605@suse.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/16/2014 04:54 AM, Juergen Gross wrote:
> 
> And shouldn't it be removed from include/linux/efi.h as well?
> 

Indeed.

	-hpa


