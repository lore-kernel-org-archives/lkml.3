Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753062Ab3GGS1G (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jul 2013 14:27:06 -0400
Received: from mail-yh0-f54.google.com ([209.85.213.54]:51271 "EHLO
	mail-yh0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752975Ab3GGS05 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jul 2013 14:26:57 -0400
Date: Sat, 06 Jul 2013 18:00:05 -0500
From: Rob Landley <rob@landley.net>
Subject: Re: [PATCH] menuconfig: Allow j/k to move down/up the menu
To: Ramkumar Ramachandra <artagnon@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Michal Marek <mmarek@suse.cz>
In-Reply-To: <1373023979-20537-1-git-send-email-artagnon@gmail.com> (from
	artagnon@gmail.com on Fri Jul  5 06:32:59 2013)
X-Mailer: Balsa 2.4.11
Message-Id: <1373151605.27613.9@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/05/2013 06:32:59 AM, Ramkumar Ramachandra wrote:
> Like in Vim.
> 
> Cc: Michal Marek <mmarek@suse.cz>
> Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
> ---
>  Unsure why nobody has done this yet.

While you're at it, why don't you add the ws up and down bindings from  
World of Warcraft?

The reason nobody has done this yet is that vi predates the invention  
of cursor keys. They keyboards Bill Joy was using in the 1970's did not  
have standardized cursor keys, in large part because you can't cursor  
around on a teletype printer. Once people started using "glass tty"  
devices (vt100 and such) cursor keys got standardized within a few  
years. They were reasonably ubiquitous by the time the IBM PC showed up  
(the vic 20 and commodore 64 and such all had them; anything that  
displayed to a television instead of through a daisy wheel).

They also didn't have ALT or control keys. The vi modal interface is a  
legacy of not having any standardized keys on the keyboard except  
letters, numbers, and (for 8 bit machines) shift. (There's a song  
"double bucky" to the tune of "Rubber Ducky" that commemorates a  
particular bespoke keyboard design from MIT in the 1970's.) Even the  
punctuation was potluck for a while there, although they could copy  
manual typewriters and the IBM selectric and such for some of that.

And now you know _why_ Linux is over 20 years old and has never needed  
this.

Rob