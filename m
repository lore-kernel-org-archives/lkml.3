Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752279AbaJQKxk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 06:53:40 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:47863 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751810AbaJQKxi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 06:53:38 -0400
MIME-Version: 1.0
In-Reply-To: <543F678E.1030401@ahsoftware.de>
References: <1401142372-14148-1-git-send-email-holler@ahsoftware.de>
	<543F678E.1030401@ahsoftware.de>
Date: Fri, 17 Oct 2014 12:53:37 +0200
Message-ID: <CAH6sp9O=36FTGg4FTCywsNzdJi4PjUmiiT6_EHr=i166+NA2ng@mail.gmail.com>
Subject: Re: [PATCH 00/27] Fix common bug in most nand drivers not showing a
 device in sysfs
From: Frans Klaver <fransklaver@gmail.com>
To: Alexander Holler <holler@ahsoftware.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-mtd@lists.infradead.org, David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 16, 2014 at 8:37 AM, Alexander Holler <holler@ahsoftware.de> wrote:
>
> I wonder if anyone else will fix this in a maintainer-approved style which
> doesn't use these evil leftovers from C666 called functions.

I'll pick this up then.

Still interested in following progress?

Frans
