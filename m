Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756999AbaFYXIp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 19:08:45 -0400
Received: from mail-lb0-f180.google.com ([209.85.217.180]:42089 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756646AbaFYXIo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 19:08:44 -0400
MIME-Version: 1.0
In-Reply-To: <1403354888-15600-1-git-send-email-cascardo@linux.vnet.ibm.com>
References: <1403354888-15600-1-git-send-email-cascardo@linux.vnet.ibm.com>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Wed, 25 Jun 2014 16:08:21 -0700
X-Google-Sender-Auth: BWLxwMdjAAW36K1YlkrUoEP6EtY
Message-ID: <CAB=NE6VWa4O0nycSo55ip075MEXXB_0k4wVnorSziRQmKRUmLg@mail.gmail.com>
Subject: Re: [PATCH] cxgb4: use dev_port to identify ports
To: Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>
Cc: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Hariprasad Shenai <hariprasad@chelsio.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 21, 2014 at 5:48 AM, Thadeu Lima de Souza Cascardo
<cascardo@linux.vnet.ibm.com> wrote:
> That use was removed by commit
> 8c367fcbe6549195d2eb11e62bea233f811aad41 ("cxgb4: Do not set
> net_device::dev_id to VI index"), since dev_id should be used only when
> devices share the same MAC address.
>
> Using dev_port for cxgb4 allows different ports on the same PCI function
> to be identified.

Can you describe what issues were introduced because of this then?

  Luis
