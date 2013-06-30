Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751397Ab3F3DJY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Jun 2013 23:09:24 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:63552 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750798Ab3F3DJW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Jun 2013 23:09:22 -0400
Date: Sat, 29 Jun 2013 22:09:20 -0500
From: Rob Landley <rob@landley.net>
Subject: Re: [PATCH 1/5] initmpfs: replace MS_NOUSER in initramfs
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>
References: <1372536729.850656@landley.net> <87y59swg8z.fsf@xmission.com>
In-Reply-To: <87y59swg8z.fsf@xmission.com> (from ebiederm@xmission.com on
	Sat Jun 29 20:15:40 2013)
X-Mailer: Balsa 2.4.11
Message-Id: <1372561760.2776.161@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/29/2013 08:15:40 PM, Eric W. Biederman wrote:
> Rob Landley <rob@landley.net> writes:
> 
> > From: Rob Landley <rob@landley.net>
> >
> > Mounting MS_NOUSER prevents --bind mounts from rootfs. Prevent new  
> rootfs
> > mounts with a different mechanism that doesn't affect bind mounts.
> 
> I don't see patches 4 and 5 so I don't know if you have covered this
> elsewhere but a very important part of the reason for MS_NOUSER is to
> prevent unmounting of rootfs.
> 
> The entire vfs breaks if you are allowed to unmount rootfs, and it
> appears this patch is allowing that.

I mean I tried "mount --move / home". (--bind worked.)

Long day...

Rob