Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753501AbaIVJhS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 05:37:18 -0400
Received: from mail-lb0-f182.google.com ([209.85.217.182]:48269 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753215AbaIVJhO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 05:37:14 -0400
Message-ID: <541FEDC5.9080405@gmail.com>
Date: Mon, 22 Sep 2014 12:37:09 +0300
From: Kari Suvanto <kari.tj.suvanto@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
        "Hugh Dickins <hughd@google.com>Sabrina Dubroca" <sd@queasysnail.net>,
        Valdis.Kletnieks@vt.edu, Vincent Donnefort <vdonnefort@gmail.com>,
        Bryan Wu <cooloney@gmail.com>, linux-leds@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: 3.17-rc1: leds blink workqueue causes sleeping BUGs
References: <541FD018.107@gmail.com> <20140922073726.GQ3349@type.wlan.youpi.perso.aquilenet.fr>
In-Reply-To: <20140922073726.GQ3349@type.wlan.youpi.perso.aquilenet.fr>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok I missed that and it did not show up with my searches. I also tested your patch on top of next-20140922 and it seems to work.  

-Kari
