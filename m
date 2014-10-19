Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751700AbaJSVYt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 17:24:49 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:41908 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993AbaJSVYq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 17:24:46 -0400
Date: Sun, 19 Oct 2014 23:24:43 +0200
From: Frans Klaver <fransklaver@gmail.com>
To: Alexander Holler <holler@ahsoftware.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-mtd@lists.infradead.org, David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>
Subject: Re: [PATCH 00/27] Fix common bug in most nand drivers not showing a
 device in sysfs
Message-ID: <20141019212443.GA9322@gmail.com>
References: <1401142372-14148-1-git-send-email-holler@ahsoftware.de>
 <543F678E.1030401@ahsoftware.de>
 <CAH6sp9O=36FTGg4FTCywsNzdJi4PjUmiiT6_EHr=i166+NA2ng@mail.gmail.com>
 <54413B9B.9030702@ahsoftware.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <54413B9B.9030702@ahsoftware.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 17, 2014 at 05:54:03PM +0200, Alexander Holler wrote:
> I assume the result will be just 21 one-line-patches anyway, missing
> the chance to avoid similiar silly patch series in the future by
> creating a common function (which even reduces code size over all).

That's to be expected, yes. A single patch may even be defensible. I
share your concern that it's easier to get it wrong than it is to get it
right, though.

> So, if you like, just add my Signed-off-by too, there isn't really much
> one could do wrong. ;)

Sure.

Frans
