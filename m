Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753817AbaGQSUR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 14:20:17 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:38250 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343AbaGQSUP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 14:20:15 -0400
MIME-Version: 1.0
In-Reply-To: <20140715.161858.1681599596014493824.davem@davemloft.net>
References: <1405348645-1995-1-git-send-email-teg@jklm.no>
	<1405348645-1995-3-git-send-email-teg@jklm.no>
	<20140715.161858.1681599596014493824.davem@davemloft.net>
Date: Thu, 17 Jul 2014 21:20:14 +0300
Message-ID: <CANZNk80SxiApvMt+yQpv9xgmJoBOORq88O7=1=s8rPhrWghYXg@mail.gmail.com>
Subject: Re: [PATCH v9 3/4] net: set name_assign_type in alloc_netdev()
From: Andrey Utkin <andrey.krieger.utkin@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: teg@jklm.no, netdev@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If somebody is interested, this breaks virtualbox-modules compilation.

-- 
Andrey Utkin
