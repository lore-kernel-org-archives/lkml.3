Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755620Ab3KAKje (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 06:39:34 -0400
Received: from mail-qc0-f176.google.com ([209.85.216.176]:37909 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751532Ab3KAKjd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 06:39:33 -0400
MIME-Version: 1.0
In-Reply-To: <xmqqtxfy9zee.fsf@gitster.dls.corp.google.com>
References: <xmqqtxfy9zee.fsf@gitster.dls.corp.google.com>
From: Duy Nguyen <pclouds@gmail.com>
Date: Fri, 1 Nov 2013 17:39:02 +0700
Message-ID: <CACsJy8AynEEkGR5Yj6SdzRw4Gc7=z9zekTi2jCBkK41R_eOY2w@mail.gmail.com>
Subject: Re: [ANNOUNCE] Git v1.8.5-rc0
To: Junio C Hamano <gitster@pobox.com>
Cc: Git Mailing List <git@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 31, 2013 at 5:17 AM, Junio C Hamano <gitster@pobox.com> wrote:
>  * Magic pathspecs like ":(icase)makefile" that matches both
>    Makefile and makefile can be used in more places.

":(glob)foo/**/bar" is another nice thing that could be announced.
-- 
Duy
