Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756753AbaHYXBL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 19:01:11 -0400
Received: from mail-la0-f51.google.com ([209.85.215.51]:61033 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751780AbaHYXBI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 19:01:08 -0400
MIME-Version: 1.0
In-Reply-To: <20140825201324.GA32033@kroah.com>
References: <1408553745-3536-1-git-send-email-bobby.prani@gmail.com>
 <1408553745-3536-2-git-send-email-bobby.prani@gmail.com> <20140825201324.GA32033@kroah.com>
From: Pranith Kumar <bobby.prani@gmail.com>
Date: Mon, 25 Aug 2014 19:00:36 -0400
Message-ID: <CAJhHMCAVDQrq+5NKfhExjBLL7668GES1+KgJTacQXPuZYB+erw@mail.gmail.com>
Subject: Re: [PATCH] serial: Fix build failure caused by missing header file
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>,
        "open list:SERIAL DRIVERS" <linux-serial@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 25, 2014 at 4:13 PM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:

> Where is this failing?  What arch?  What kernel version did it show up
> in (i.e. what commit caused this problem?)
>

This was a randconfig on powerpc. I did not bisect as to which commit
introduced this since it is a simple missing header file.

-- 
Pranith
