Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756781Ab3C1Iru (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 04:47:50 -0400
Received: from eu1sys200aog118.obsmtp.com ([207.126.144.145]:53525 "EHLO
	eu1sys200aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756763Ab3C1Irs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 04:47:48 -0400
Message-ID: <515403AA.9030104@mellanox.com>
Date: Thu, 28 Mar 2013 10:47:38 +0200
From: Amir Vadai <amirv@mellanox.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>,
        "Kleber Sacilotto de Souza" <klebers@linux.vnet.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Or Gerlitz <ogerlitz@mellanox.com>
Subject: Re: [PATCH 85/86] mlx4_en: fix allocation of CPU affinity reverse-map
References: <20130326172059.136127374@goodmis.org> <20130326173613.383713136@goodmis.org>
In-Reply-To: <20130326173613.383713136@goodmis.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.222.66.109]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fix introduced a bug in SRIOV.

Should squash into it, the upstream commit:
f74d525bc973f2003b55b1f71f377e31fb5d3c8b - "net/mlx4_en: Disable RFS in
SRIOV virtual functions"

Thanks,
Amir


