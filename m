Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755401AbaDPSki (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 14:40:38 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:46944 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045AbaDPSkg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 14:40:36 -0400
Date: Wed, 16 Apr 2014 19:39:49 +0100
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Sergei Ianovich <ynvich@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Randy Dunlap <rdunlap@infradead.org>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH v4 21/21] misc: support for I-8024 in LP-8x4x
Message-ID: <20140416193949.47f4ea68@alan.etchedpixels.co.uk>
In-Reply-To: <1397668667-27328-15-git-send-email-ynvich@gmail.com>
References: <1397668411-27162-7-git-send-email-ynvich@gmail.com>
	<1397668667-27328-1-git-send-email-ynvich@gmail.com>
	<1397668667-27328-15-git-send-email-ynvich@gmail.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Apr 2014 21:17:26 +0400
Sergei Ianovich <ynvich@gmail.com> wrote:

> Status of I-8042 4 analog output channels can be managed via
> sysfs.

Surely this is an iio interface and should follow the same API as
everyone else ?

Alan
