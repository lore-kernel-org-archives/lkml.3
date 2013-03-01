Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751993Ab3CASjd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 13:39:33 -0500
Received: from mail.wdtv.com ([66.118.69.84]:47300 "EHLO mail.wdtv.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750779Ab3CASjc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 13:39:32 -0500
From: Gene Heskett <gheskett@wdtv.com>
To: linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] Load keys from signed PE binaries
Date: Fri, 1 Mar 2013 13:39:29 -0500
References: <87ppzo79in.fsf@mid.deneb.enyo.de> <loom.20130227T210924-53@post.gmane.org> <20130301182157.GA1306@srcf.ucam.org>
In-Reply-To: <20130301182157.GA1306@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="windows-1256"
Content-Transfer-Encoding: 7bit
Message-Id: <201303011339.29302.gheskett@wdtv.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 01 March 2013, Matthew Garrett wrote:
>On Wed, Feb 27, 2013 at 08:35:45PM +0000, ownssh wrote:
>> Matthew Garrett <mjg59 <at> srcf.ucam.org> writes:
>> > There's no way to update the UEFI key database without the update
>> > being signed by an already trusted key, so what you're proposing
>> > isn't possible.
>> 
>> I confused.
>> Isn't custom mode can add user's own key?
>
>Yes, but that involves physically-present end-user interaction. A
>bootloader can't do it even if it's signed by Microsoft.

Thats a false flag Matthew.  We have been 'touch'ing a file to trigger an 
action on reboot, then typing "reboot" from 2000 miles away for at least a 
decade.  I fail to see why that idea couldn't be expanded to do this too.

Cheers, Gene
-- 
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
My web page: <http://coyoteden.dyndns-free.com:85/gene> is up!
My views 
<http://www.armchairpatriot.com/What%20Has%20America%20Become.shtml>
Friends may come and go, but enemies accumulate.
		-- Thomas Jones
I was taught to respect my elders, but its getting 
harder and harder to find any...
