Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753426AbaI3ObT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 10:31:19 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:43496 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752417AbaI3ObQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 10:31:16 -0400
Message-ID: <1412087471.10205.12.camel@L80496>
Subject: Re: [PATCH] tc: fix warning and coding style
From: Thibaut Robert <thibaut.robert@gmail.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: "Maciej W. Rozycki" <macro@linux-mips.org>,
        Ralf Baechle <ralf@linux-mips.org>,
        Linux MIPS Mailing List <linux-mips@linux-mips.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 30 Sep 2014 16:31:11 +0200
In-Reply-To: <CAMuHMdWHMK7NxX9AUg3ihwds41dKW26A_jFnZELw5N9shMaBKw@mail.gmail.com>
References: <1412079396-26005-1-git-send-email-thibaut.robert@gmail.com>
	 <CAMuHMdXj=b0G7foTRkcEtRC_De8+WjVefxBfW=s1sjaXLeF5nQ@mail.gmail.com>
	 <1412085083.10205.8.camel@L80496>
	 <CAMuHMdWHMK7NxX9AUg3ihwds41dKW26A_jFnZELw5N9shMaBKw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 30 septembre 2014 à 16:08 +0200, Geert Uytterhoeven a écrit :
> I guess that's acceptable, as tc is probably limited to 32-bit anyway. Maciej?
> 
> Note that there's also %pa, for phys_addr_t/resource_size_t.
Yes, but unfortunately that needs a reference so we can't use it.

Thibaut

