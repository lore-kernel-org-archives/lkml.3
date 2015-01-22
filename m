Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753532AbbAVBQ3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 20:16:29 -0500
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:54602 "HELO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753319AbbAVBQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 20:16:19 -0500
MIME-Version: 1.0
In-Reply-To: <1421887372-56414-3-git-send-email-joestringer@nicira.com>
References: <1421887372-56414-1-git-send-email-joestringer@nicira.com>
	<1421887372-56414-3-git-send-email-joestringer@nicira.com>
Date: Wed, 21 Jan 2015 17:16:18 -0800
Message-ID: <CALnjE+qkro-kwk8UeTzzyCsC5uRi1meO_wMD2bk5O3bqHBOzzg@mail.gmail.com>
Subject: Re: [PATCH net-next v14 2/5] openvswitch: Refactor ovs_flow_tbl_insert().
From: Pravin Shelar <pshelar@nicira.com>
To: Joe Stringer <joestringer@nicira.com>
Cc: netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        "dev@openvswitch.org" <dev@openvswitch.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 21, 2015 at 4:42 PM, Joe Stringer <joestringer@nicira.com> wrote:
> Rework so that ovs_flow_tbl_insert() calls flow_{key,mask}_insert().
> This tidies up a future patch.
>
> Signed-off-by: Joe Stringer <joestringer@nicira.com>
Acked-by: Pravin B Shelar <pshelar@nicira.com>
