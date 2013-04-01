Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759305Ab3DATFB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 15:05:01 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:39841 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759252Ab3DATFA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 15:05:00 -0400
Date: Mon, 1 Apr 2013 12:04:57 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Michael =?iso-8859-1?Q?B=FCsch?= <m@bues.ch>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: event subsystem: Define conference event types
Message-ID: <20130401190457.GA22044@kroah.com>
References: <20130401140856.776f11f7@milhouse>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130401140856.776f11f7@milhouse>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 01, 2013 at 02:08:56PM +0200, Michael Büsch wrote:
> In order to improve the media coverage of important developer
> conference events, extend the Linux event subsystem by corresponding
> event type numbers.
> 
> Instead of referring to events by cryptic acronyms that nobody
> knows the real meaning of, use even shorter acronyms defined to
> hexadecimal numbers that every real hacker is familiar with.
> 
> Signed-off-by: Michael Buesch <m@bues.ch>


Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Nicely done :)
