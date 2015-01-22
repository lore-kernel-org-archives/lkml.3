Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753321AbbAVBQT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 20:16:19 -0500
Received: from na3sys009aog127.obsmtp.com ([74.125.149.107]:51277 "HELO
	na3sys009aog127.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752978AbbAVBQM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 20:16:12 -0500
MIME-Version: 1.0
In-Reply-To: <1421887372-56414-2-git-send-email-joestringer@nicira.com>
References: <1421887372-56414-1-git-send-email-joestringer@nicira.com>
	<1421887372-56414-2-git-send-email-joestringer@nicira.com>
Date: Wed, 21 Jan 2015 17:16:11 -0800
Message-ID: <CALnjE+ocnU76Ech=kyU7zR+BM74-3oyjxpMoHp92uCe-6opogg@mail.gmail.com>
Subject: Re: [PATCH net-next v14 1/5] openvswitch: Refactor ovs_nla_fill_match().
From: Pravin Shelar <pshelar@nicira.com>
To: Joe Stringer <joestringer@nicira.com>
Cc: netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        "dev@openvswitch.org" <dev@openvswitch.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 21, 2015 at 4:42 PM, Joe Stringer <joestringer@nicira.com> wrote:
> Refactor the ovs_nla_fill_match() function into separate netlink
> serialization functions ovs_nla_put_{unmasked_key,mask}(). Modify
> ovs_nla_put_flow() to handle attribute nesting and expose the 'is_mask'
> parameter - all callers need to nest the flow, and callers have better
> knowledge about whether it is serializing a mask or not.
>
> Signed-off-by: Joe Stringer <joestringer@nicira.com>

Acked-by: Pravin B Shelar <pshelar@nicira.com>
