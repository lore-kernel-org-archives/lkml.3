Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760568AbaGEDYO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 23:24:14 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:65488 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760543AbaGEDYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 23:24:10 -0400
Message-ID: <1404530647.5148.21.camel@marge.simpson.net>
Subject: Re: Scalability Question
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Nick Krause <xerofoify@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Sat, 05 Jul 2014 05:24:07 +0200
In-Reply-To: <CAPDOMVgP5WBDqQTLFi=PNY1ykBR1c0QnQdPYYAmN8cDYnknFbQ@mail.gmail.com>
References: <CAPDOMVgP5WBDqQTLFi=PNY1ykBR1c0QnQdPYYAmN8cDYnknFbQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-07-04 at 16:40 -0400, Nick Krause wrote: 
> I am curious after reading some outdated kernel papers, how scalable
> is the kernel of
> late? I am curious mostly in memory and cpu subsystems as file systems
> will change
> based on user's choice.

You can currently configure for up to 8192 CPUs.  I've not seen any
benchmark data whatsoever for huge boxen, have no idea where which
subsystem crumbles.  SGI asked for the increase to 8192, so presumably
do manage to squeeze acceptable performance out of size XXXXL boxen.

-Mike

