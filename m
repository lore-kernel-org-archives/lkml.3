Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755370Ab3FDRga (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 13:36:30 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:56073 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753284Ab3FDRg1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 13:36:27 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: Re: [PATCH] net: core: move mac_pton() to lib/net_utils.c
Date: Tue, 4 Jun 2013 19:36:20 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1370364386-5034-1-git-send-email-andy.shevchenko@gmail.com>
In-Reply-To: <1370364386-5034-1-git-send-email-andy.shevchenko@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201306041936.21055.arnd@arndb.de>
X-Provags-ID: V02:K0:l0qF+NAX9t0w35gi+ZVdYhRQyFUFx+iBWHBLMLeWKMy
 dc7SnbXpAJgoGr6NW645Kol002NGf8yJ+58gTZUXP81T7ekRvp
 VV9unGmhwrJdEw9NqGVdU/fHlL7J6Ees1k7rwanSU4FLl3qbfO
 En/voGoj6lCrZAnu66x/Brx7H8WvTGKxkjCOw5YMpVCjyhpNNL
 rb/0VgBdF74RU7aJHGWnH6geVu/NUpQe4Wiu+6eFng5qON0eox
 ayRCb7cpEKdpAOcDL2cFOUuRZo9FXmo6bIyh3kPAdZNNChmg0w
 Wf4mZ81qf8uDdSihakQLp2voPzoRTCxSbhPDcnV+CYir22RcaC
 aF1dmDvymgG1kV6QNwbo=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 04 June 2013, Andy Shevchenko wrote:
> 
> Since we have at least one user of this function outside of CONFIG_NET
> scope, we have to provide this function independently. The proposed
> solution is to move it under lib/net_utils.c with corresponding
> configuration variable and select wherever it is needed.
> 
> Signed-off-by: Andy Shevchenko <andy.shevchenko@gmail.com>
> Reported-by: Arnd Bergmann <arnd@arndb.de>

Acked-by: Arnd Bergmann <arnd@arndb.de>

Thanks for providing a fix so quickly!
