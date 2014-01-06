Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755972AbaAFVKF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 16:10:05 -0500
Received: from mail-ig0-f174.google.com ([209.85.213.174]:42483 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755635AbaAFVKD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 16:10:03 -0500
MIME-Version: 1.0
In-Reply-To: <D60EADB9-69D0-4B80-9FDD-5C0FE0C18F54@heider.io>
References: <CALkWK0=--MxTMTmdYzKotUfbctgc09rJ6R=9WB2XHTP-jnbz-A@mail.gmail.com>
 <D60EADB9-69D0-4B80-9FDD-5C0FE0C18F54@heider.io>
From: Ramkumar Ramachandra <artagnon@gmail.com>
Date: Tue, 7 Jan 2014 02:39:22 +0530
Message-ID: <CALkWK0=qTftgogUCyehi-zQWudYC0VTOUjEnSUQYWYv32+JENg@mail.gmail.com>
Subject: Re: apple_gmux: switcheroo not working on a 2013 MBP
To: Andreas Heider <andreas@heider.io>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Seth Forshee <seth.forshee@canonical.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andreas,

Andreas Heider wrote:
> that means that something is still using the GPU, try DIGD or alternatively
> shutting down your X-server before switching.

When I try DIGD, I get:

  vga_switcheroo: setting delayed switch to client 0

Then, when I shut down X, I get a blank screen.

When I try IGN after shutting down X, I get the same message:

  vga_switcheroo: client 1 refused switch

> I think there are still some EDID issues because
> https://lkml.org/lkml/2012/8/3/300 never got merged, so even after shutting
> down X you might get a black screen, but it should hopefully work with
> external displays.

The series is really old! Why is gmux in such a shabby state today,
and more importantly: how do I get started hacking on it?

Thanks.

Ram
