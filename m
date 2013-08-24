Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754750Ab3HZAL1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Aug 2013 20:11:27 -0400
Received: from frisell.zx2c4.com ([192.95.5.64]:57370 "EHLO frisell.zx2c4.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754162Ab3HZALY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Aug 2013 20:11:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=zx2c4.com; h=mime-version
	:in-reply-to:references:date:message-id:subject:from:to:cc
	:content-type; q=dns; s=mail; b=uGrUhb4K/DEhld/CyUJsyI/VR9yt62M0
	+uKDM9TZIv1gXwfrPx7OMkMfCdnvtzSxaOg5YQtfPYLRBzDBRKciEbCtZccOkF5K
	9LMkqn1x0Fd0ldOLIbmYjGjHEZi/NpW0dgsG6K+Iyis3NeTcI/Q293hCPM4282mg
	Yv7oUCh2nb4=
MIME-Version: 1.0
In-Reply-To: <20130823181826.GB27893@khazad-dum.debian.net>
References: <1377180132-4933-1-git-send-email-Jason@zx2c4.com>
	<1377180132-4933-3-git-send-email-Jason@zx2c4.com>
	<20130823181826.GB27893@khazad-dum.debian.net>
Date: Sat, 24 Aug 2013 22:29:53 +0200
Message-ID: <CAHmME9oHDqoEA7Abuvr2iE5Abb_T_+GAuK=KJpC54g8q3vZH9Q@mail.gmail.com>
Subject: Re: [PATCH 3/3] thinkpad_acpi: Wire unused micmute LED to capslock
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: linux-acpi@vger.kernel.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, mjg@redhat.com, rjw@sisk.pl,
        len.brown@intel.com, dtor@insightbb.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 23, 2013 at 8:18 PM, Henrique de Moraes Holschuh
<hmh@hmh.eng.br> wrote:
> NACK.  This we won't do.  It is a LED misuse, and it will get in the way
> when we finally put that LED to its proper use.

Agreed. Please see my response to mjg.
