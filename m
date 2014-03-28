Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751539AbaC1WMm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 18:12:42 -0400
Received: from na3sys009aog138.obsmtp.com ([74.125.149.19]:54915 "HELO
	na3sys009aog138.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751439AbaC1WMl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 18:12:41 -0400
MIME-Version: 1.0
In-Reply-To: <1395602563-15221-1-git-send-email-monamagarwal123@gmail.com>
References: <1395602563-15221-1-git-send-email-monamagarwal123@gmail.com>
From: Jesse Gross <jesse@nicira.com>
Date: Fri, 28 Mar 2014 15:12:20 -0700
Message-ID: <CAEP_g=8Uk+i0TybOcE0x2WMMhnnv0RfDOsAOgDav+fN227fhvw@mail.gmail.com>
Subject: Re: [PATCH] net/openvswitch: Use with RCU_INIT_POINTER(x, NULL) in vport-gre.c
To: Monam Agarwal <monamagarwal123@gmail.com>
Cc: David Miller <davem@davemloft.net>,
        "dev@openvswitch.org" <dev@openvswitch.org>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 23, 2014 at 12:22 PM, Monam Agarwal
<monamagarwal123@gmail.com> wrote:
> This patch replaces rcu_assign_pointer(x, NULL) with RCU_INIT_POINTER(x, NULL)
>
> The rcu_assign_pointer() ensures that the initialization of a structure
> is carried out before storing a pointer to that structure.
> And in the case of the NULL pointer, there is no structure to initialize.
> So, rcu_assign_pointer(p, NULL) can be safely converted to RCU_INIT_POINTER(p, NULL)
>
> Signed-off-by: Monam Agarwal <monamagarwal123@gmail.com>

Applied.
