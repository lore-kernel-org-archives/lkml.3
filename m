Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755208AbaCKNJp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 09:09:45 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:61166 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755142AbaCKNJR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 09:09:17 -0400
MIME-Version: 1.0
In-Reply-To: <20140308024016.GA24685@srcf.ucam.org>
References: <1385688949-7101-1-git-send-email-andreas.noever@gmail.com>
 <20131202162938.GA11241@srcf.ucam.org> <20140304000904.GA6623@srcf.ucam.org>
 <CAMxnaaVEg5ohZwopnDdMfoDseQy4Xoqbm-J3BzOcxDS=HVQN2w@mail.gmail.com> <20140308024016.GA24685@srcf.ucam.org>
From: Andreas Noever <andreas.noever@gmail.com>
Date: Tue, 11 Mar 2014 14:08:55 +0100
Message-ID: <CAMxnaaXQgE4gvfw7ocO4yTqGYvTTo+jwCde5caXpWJ8i1chDqg@mail.gmail.com>
Subject: Re: [PATCH 00/12] Thunderbolt hotplug support for Apple hardware
 (testers needed)
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 8, 2014 at 3:40 AM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> Ok, can you try this one?
>

That seems to do it. I was afraid that setting OSDW globally would
affect other parts (USB?) But that does not seem to be the case.

What is the reason for clearing the PME flag?

Andreas
