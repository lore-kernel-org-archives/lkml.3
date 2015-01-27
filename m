Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758888AbbA0Rih (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 12:38:37 -0500
Received: from mail-ig0-f172.google.com ([209.85.213.172]:52133 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758525AbbA0Ric (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 12:38:32 -0500
MIME-Version: 1.0
In-Reply-To: <54C78540.6080404@cogentembedded.com>
References: <1422322574-6188-1-git-send-email-ddecotig@gmail.com>
 <1422322574-6188-6-git-send-email-ddecotig@gmail.com> <54C78540.6080404@cogentembedded.com>
From: David Decotigny <ddecotig@gmail.com>
Date: Tue, 27 Jan 2015 09:38:11 -0800
X-Google-Sender-Auth: M8w3ZAk4_TYK374RSlVjFTxY9Ts
Message-ID: <CAG88wWaLxH9qyNDw4jVYBvcx-mQw-2iriS5uvt_A_5ThoETG5A@mail.gmail.com>
Subject: Re: [PATCH net-next v1 05/18] net: tx4939: use __ethtool_get_ksettings
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        Ben Hutchings <ben@decadent.org.uk>, Amir Vadai <amirv@mellanox.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eugenia Emantayev <eugenia@mellanox.co.il>,
        Or Gerlitz <ogerlitz@mellanox.com>, Ido Shamay <idos@mellanox.com>,
        Joe Perches <joe@perches.com>, Saeed Mahameed <saeedm@mellanox.com>,
        Govindarajulu Varadarajan <_govind@gmx.com>,
        Venkata Duvvuru <VenkatKumar.Duvvuru@emulex.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Eyal Perry <eyalpe@mellanox.com>, Pravin B Shelar <pshelar@nicira.com>,
        Ed Swierk <eswierk@skyportsystems.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 27, 2015 at 4:32 AM, Sergei Shtylyov
<sergei.shtylyov@cogentembedded.com> wrote:
> linux-mips@linux-mips.org.

Thanks, added mips + usnic + fcoe in my copy for the next wave of
reviews. Also updated the subject line.
