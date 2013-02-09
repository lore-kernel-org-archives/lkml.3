Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932344Ab3BIBDK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 20:03:10 -0500
Received: from mail-wi0-f182.google.com ([209.85.212.182]:63154 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932276Ab3BIBDI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 20:03:08 -0500
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
Organization: BZH lan
To: linux-kbuild@vger.kernel.org, Roland Eggner <edvx1@systemanalysen.net>
Subject: Re: [PATCH resend v3 3/3] kconfig: nconf:  add vi-style navigation keys
Date: Sat, 9 Feb 2013 02:03:03 +0100
User-Agent: KMail/1.13.5 (Linux/3.7.3-treguer; KDE/4.4.5; x86_64; ; )
Cc: Dmitry Voytik <dvv.kernel@gmail.com>, Michal Marek <mmarek@suse.cz>,
        Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org
References: <20130201182237.GA11098@mobil.systemanalysen.net> <20130201183357.GD11098@mobil.systemanalysen.net>
In-Reply-To: <20130201183357.GD11098@mobil.systemanalysen.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201302090203.04055.yann.morin.1998@free.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roland, All,

On Friday 01 February 2013 Roland Eggner wrote:
> Add vi-style navigation keys, based on initial work by Dmitry Voytik.

As much I am a unconditional vim user, I doubt this is a sane idea to
include this, as it conflicts with the established UI that people expect,
especially since <h> is remapped and people already rely on <h> to provide
help, not do any other weird thing (like exiting the current submenu).

Regards,
Yann E. MORIN.

-- 
.-----------------.--------------------.------------------.--------------------.
|  Yann E. MORIN  | Real-Time Embedded | /"\ ASCII RIBBON | Erics' conspiracy: |
| +33 662 376 056 | Software  Designer | \ / CAMPAIGN     |  ___               |
| +33 223 225 172 `------------.-------:  X  AGAINST      |  \e/  There is no  |
| http://ymorin.is-a-geek.org/ | _/*\_ | / \ HTML MAIL    |   v   conspiracy.  |
'------------------------------^-------^------------------^--------------------'

