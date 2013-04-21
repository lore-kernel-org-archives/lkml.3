Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753657Ab3DUONu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Apr 2013 10:13:50 -0400
Received: from eu1sys200aog110.obsmtp.com ([207.126.144.129]:52007 "EHLO
	eu1sys200aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753543Ab3DUONs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Apr 2013 10:13:48 -0400
Message-ID: <5173F411.1030806@mellanox.com>
Date: Sun, 21 Apr 2013 17:13:37 +0300
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
Subject: Re: [RFC-v4 9/9] iser-target: Add iSCSI Extensions for RDMA (iSER)
 target driver
References: <1365799962-13543-1-git-send-email-nab@linux-iscsi.org> <1365799962-13543-10-git-send-email-nab@linux-iscsi.org>
In-Reply-To: <1365799962-13543-10-git-send-email-nab@linux-iscsi.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.222.66.109]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/04/2013 23:52, Nicholas A. Bellinger wrote:
> From: Nicholas Bellinger<nab@linux-iscsi.org>
>
> This patch adds support for iSCSI Extensions for RDMA target mode,
> and includes CQ pooling per isert_device context distributed across
> multiple active iser target sessions.

Cool, feel free to ad my S.O.B here

Signed-off-by: Or Gerlitz <ogerlitz@mellanox.com>
