Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752840AbaBZQjE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 11:39:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:12029 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751268AbaBZQjB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 11:39:01 -0500
Date: Wed, 26 Feb 2014 10:46:54 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
        ebiederm@xmission.com, hpa@zytor.com, mjg59@srcf.ucam.org,
        greg@kroah.com, jkosina@suse.cz
Subject: Re: [PATCH 06/11] kexec: A new system call, kexec_file_load, for in
 kernel kexec
Message-ID: <20140226154654.GB23022@redhat.com>
References: <1390849071-21989-1-git-send-email-vgoyal@redhat.com>
 <1390849071-21989-7-git-send-email-vgoyal@redhat.com>
 <20140221145910.GE11531@pd.tnic>
 <20140224164131.GJ4631@redhat.com>
 <20140226153709.GE22639@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140226153709.GE22639@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 26, 2014 at 04:37:09PM +0100, Borislav Petkov wrote:
> On Mon, Feb 24, 2014 at 11:41:31AM -0500, Vivek Goyal wrote:
> > Right now there is only one user. But once other image loader support
> > comes along or other arches support file based kexec, they can make
> > use of same function.
> > 
> > This is a pretty important modification as it decides what's the starting
> > point of next kernel image. I wanted to make it a function callable by
> > users who wanted to modify it instead of of letting them directly 
> > modify image->start.
> 
> But are you expecting any other way to set image->start by the other
> arches/image loaders?

No. I am expecting other loaders to just call this function to set the
start of kernel image.

Thanks
Vivek
