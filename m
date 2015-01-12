Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754243AbbALVEp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 16:04:45 -0500
Received: from 251.110.2.81.in-addr.arpa ([81.2.110.251]:41792 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753420AbbALVEn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 16:04:43 -0500
Date: Mon, 12 Jan 2015 21:04:22 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Ezequiel Garcia <ezequiel.garcia@imgtec.com>
Cc: Andrew Bresticker <abrestic@chromium.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        James Hartley <james.hartley@imgtec.com>,
        "Arnd Bergmann" <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-pwm@vger.kernel.org>, <vladimir_zapolskiy@mentor.com>,
        Naidu Tellapati <naidu.tellapati@gmail.com>,
        Naidu Tellapati <Naidu.Tellapati@imgtec.com>,
        Sai Masarapu <Sai.Masarapu@imgtec.com>
Subject: Re: [PATCH v8 1/2] pwm: Imagination Technologies PWM DAC driver
Message-ID: <20150112210422.39f715a2@lxorguk.ukuu.org.uk>
In-Reply-To: <1420826088-13113-2-git-send-email-ezequiel.garcia@imgtec.com>
References: <1420826088-13113-1-git-send-email-ezequiel.garcia@imgtec.com>
	<1420826088-13113-2-git-send-email-ezequiel.garcia@imgtec.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);

What if you've not been given a resource ?

Otherwise looks fine to me
