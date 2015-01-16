Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753862AbbAPIve (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 03:51:34 -0500
Received: from mail-lb0-f178.google.com ([209.85.217.178]:38181 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753748AbbAPIvc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 03:51:32 -0500
Date: Fri, 16 Jan 2015 09:51:42 +0100
From: Johan Hovold <johan@kernel.org>
To: Jamal Mohammad <md.jamalmohiuddin@gmail.com>
Cc: Johan Hovold <johan@kernel.org>, Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] gpio: gpio-dln2: Added a Blank line after declaration
Message-ID: <20150116085142.GF30960@localhost>
References: <1421161778-5671-1-git-send-email-md.jamalmohiuddin@gmail.com>
 <CACRpkdb2=YyVtFFMqMQrWCVFhtnBOdmw57W0tktYn1c2fS8uQw@mail.gmail.com>
 <20150115181032.GD30960@localhost>
 <CAP8vtK+vHR_7h_SYWfBNDZkAqUbtEdSDqw+AteZWGqoY37tYTQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAP8vtK+vHR_7h_SYWfBNDZkAqUbtEdSDqw+AteZWGqoY37tYTQ@mail.gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ Please do not top-post. ]

On Fri, Jan 16, 2015 at 10:22:56AM +0530, Jamal Mohammad wrote:
> I think you are write ... checkpatch.pl was giving the error at the
> line so i added a blank line... i will send an updated patch..

You should not trust checkpatch.pl blindly, and not run it on in-kernel
files either. Use it on your own patches as a way to find (possible)
mistakes before submission.

Johan
