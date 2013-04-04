Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758088Ab3DDJVF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 05:21:05 -0400
Received: from eu1sys200aog117.obsmtp.com ([207.126.144.143]:43381 "EHLO
	eu1sys200aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758049Ab3DDJVC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 05:21:02 -0400
Message-ID: <515D45F6.9040903@mellanox.com>
Date: Thu, 4 Apr 2013 12:20:54 +0300
From: Or Gerlitz <ogerlitz@mellanox.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
CC: target-devel <target-devel@vger.kernel.org>,
        linux-rdma <linux-rdma@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Roland Dreier <roland@kernel.org>,
        Alexander Nezhinsky <alexandern@mellanox.com>
Subject: Re: [RFC-v3 9/9] iser-target: Add iSCSI Extensions for RDMA (iSER)
 target driver
References: <1365060256-21506-1-git-send-email-nab@linux-iscsi.org> <1365060256-21506-10-git-send-email-nab@linux-iscsi.org>
In-Reply-To: <1365060256-21506-10-git-send-email-nab@linux-iscsi.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.222.66.109]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/04/2013 10:24, Nicholas A. Bellinger wrote:
> +
> +void isert_cq_tx_callback(struct ib_cq *, void *);
> +void isert_cq_rx_callback(struct ib_cq *, void *);
> +void isert_free_rx_descriptors(struct isert_conn *);
any reason not to have these as static functions (same for isert_cq_rx_work)
