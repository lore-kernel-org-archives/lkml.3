Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932717AbbA0McL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 07:32:11 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:58642 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932656AbbA0McF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 07:32:05 -0500
Message-ID: <54C78540.6080404@cogentembedded.com>
Date: Tue, 27 Jan 2015 15:32:00 +0300
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: David Decotigny <ddecotig@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ben Hutchings <ben@decadent.org.uk>, Amir Vadai <amirv@mellanox.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-api@vger.kernel.org
CC: Eric Dumazet <edumazet@google.com>,
        Eugenia Emantayev <eugenia@mellanox.co.il>,
        Or Gerlitz <ogerlitz@mellanox.com>, Ido Shamay <idos@mellanox.com>,
        Joe Perches <joe@perches.com>, Saeed Mahameed <saeedm@mellanox.com>,
        Govindarajulu Varadarajan <_govind@gmx.com>,
        Venkata Duvvuru <VenkatKumar.Duvvuru@Emulex.Com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Eyal Perry <eyalpe@mellanox.com>, Pravin B Shelar <pshelar@nicira.com>,
        Ed Swierk <eswierk@skyportsystems.com>,
        David Decotigny <decot@googlers.com>
Subject: Re: [PATCH net-next v1 05/18] net: tx4939: use __ethtool_get_ksettings
References: <1422322574-6188-1-git-send-email-ddecotig@gmail.com> <1422322574-6188-6-git-send-email-ddecotig@gmail.com>
In-Reply-To: <1422322574-6188-6-git-send-email-ddecotig@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 1/27/2015 4:36 AM, David Decotigny wrote:

> From: David Decotigny <decot@googlers.com>

> Signed-off-by: David Decotigny <decot@googlers.com>
> ---
>   arch/mips/txx9/generic/setup_tx4939.c | 7 ++++---
>   1 file changed, 4 insertions(+), 3 deletions(-)

    I don't think "net: " prefix applies here.
    And you should have CC'ed linux-mips@linux-mips.org.

WBR, Sergei

