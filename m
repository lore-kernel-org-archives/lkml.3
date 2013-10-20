Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751987Ab3JTXlS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Oct 2013 19:41:18 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:39429 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751905Ab3JTXlR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Oct 2013 19:41:17 -0400
MIME-Version: 1.0
In-Reply-To: <CAFqkpAYZCrHgxsFJ+3nNzu=RuyFX0ao9ivGb_H4J1n+u01h4qQ@mail.gmail.com>
References: <CAFqkpAYZCrHgxsFJ+3nNzu=RuyFX0ao9ivGb_H4J1n+u01h4qQ@mail.gmail.com>
Date: Mon, 21 Oct 2013 05:11:16 +0530
Message-ID: <CAFqkpAYxeDoZwpBfgkNtTvPJQ4J7CEamvnZX6icXY1N8ALU3-w@mail.gmail.com>
Subject: Re: Classifying user and kernel pages
From: Piyus Kedia <piyuskedia@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The user pages are generally allocated using GFP_USER or GFP_HIGHMEM
flags. The linux kernel treats GFP_USER and GFP_KERNEL as same. So,
there is no way you can tell whether a physical page belongs to user
process or not using physical frame number.

Piyus

On Fri, Oct 4, 2013 at 12:19 AM, Piyus Kedia <piyuskedia@gmail.com> wrote:
> Hi All,
>
> Does anybody know if there is a way in Linux Kernel to find whether a
> physical page is a user page or it is kernel page. A kernel page is
> only accessed by kernel and it doesn't belong to any user process.
>
> Thanks,
> Piyus
