Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758368AbaKUNa6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 08:30:58 -0500
Received: from mout.perfora.net ([74.208.4.197]:54021 "EHLO mout.perfora.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755059AbaKUNa4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 08:30:56 -0500
Message-ID: <1416576601.2744.11.camel@localhost.localdomain>
Subject: Re: [PATCH] ARM: tegra: colibri t30: fix on-module ethernet
From: Marcel Ziswiler <marcel@ziswiler.com>
To: swarren@wwwdotorg.org
Cc: thierry.reding@gmail.com, linux@arm.linux.org.uk,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org,
        stefan@agner.ch
Date: Fri, 21 Nov 2014 14:30:01 +0100
In-Reply-To: <1416571072.2744.4.camel@localhost.localdomain>
References: <b1cdc96ce8bb15059d7eea282f6586a826bee124.1416566157.git.marcel@ziswiler.com>
	 <1416571072.2744.4.camel@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:uNAOE15NjcRmrbUxNgh8mYjV6cZ+Ecur+If5QXZIu1q
 P51PeC0bDsS4z15t/DLH0baHxlv7Wg8Peuevnqo9XbJG51xdSJ
 kS0l1qMtAdHTLsxoJX0av47TcAJmHB8ewtaklBqdxN+UadXwsh
 U49no/Cz2c+Zj4E12IuK0le+QHmoyXOzH2KVd0f+FOhbUDXPDu
 oYX7klS/bPW6L4CTyYM/OSZ54T+S8oIL+WdzCPhSIXtKSEWfmp
 fbVMOIryUQ02bBjvmX+2NYtiaGh0cGfBfJ9YRY/0GQ/b0YVZhz
 +OkWLQX0ij0kn3WjZ3kAbbSR40dh7xZiIajceWqWBklQYIQRpP
 S9YFtN9lKfbt9tHmX8LB8wpVtiH1bN2aFNCbRP4y9
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-11-21 at 12:57 +0100, Marcel Ziswiler wrote:
> Doing automatic power-cycle tests revealed that this is still not enough
> and a proper reset-cycle might be required. However I don't know as of
> yet how one can easily do that in mainline with a USB device otherwise
> not mentioned anywhere in the device tree. Any ideas?

OK, looks like I need something as follows just wondering how far it can
go (e.g. not even in -next as of yet):

http://thread.gmane.org/gmane.linux.kernel/1682436

