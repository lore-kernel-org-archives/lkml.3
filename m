Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754299AbaGAVX4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 17:23:56 -0400
Received: from mail-we0-f175.google.com ([74.125.82.175]:42870 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752150AbaGAVXy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 17:23:54 -0400
Date: Tue, 1 Jul 2014 22:23:51 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Vivek Goyal <vgoyal@redhat.com>, linux-kernel@vger.kernel.org,
        kexec@lists.infradead.org, ebiederm@xmission.com, hpa@zytor.com,
        mjg59@srcf.ucam.org, greg@kroah.com, bp@alien8.de, dyoung@redhat.com,
        chaowang@redhat.com, bhe@redhat.com, linux-efi@vger.kernel.org
Subject: Re: [PATCH 15/15] kexec: Support kexec/kdump on EFI systems
Message-ID: <20140701212351.GK7539@console-pimps.org>
References: <1403814824-7587-1-git-send-email-vgoyal@redhat.com>
 <1403814824-7587-16-git-send-email-vgoyal@redhat.com>
 <20140701194605.GJ7539@console-pimps.org>
 <20140701131419.454a3fc32fcc84a43b668c50@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140701131419.454a3fc32fcc84a43b668c50@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 01 Jul, at 01:14:19PM, Andrew Morton wrote:
> 
> This?
> 
> From: Andrew Morton <akpm@linux-foundation.org>
> Subject: kexec-support-kexec-kdump-on-efi-systems-fix
> 
> s/get_efi/efi_get/g, per Matt
> 
> Cc: Vivek Goyal <vgoyal@redhat.com>
> Cc: Matt Fleming <matt@console-pimps.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Yep, looks spot on. Thanks Andrew.

-- 
Matt Fleming, Intel Open Source Technology Center
