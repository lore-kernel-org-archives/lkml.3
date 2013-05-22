Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757660Ab3EVWNs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 18:13:48 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:45304 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757596Ab3EVWNj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 18:13:39 -0400
Date: Wed, 22 May 2013 15:13:38 -0700 (PDT)
Message-Id: <20130522.151338.2181176723987593238.davem@davemloft.net>
To: bjorn@mork.no
Cc: Christian.Schmiedl@gemalto.com, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hans-Christoph.Schemmel@gemalto.com
Subject: Re: [PATCH] qmi_wwan: Added support for Cinterion's PLxx WWAN
 Interface
From: David Miller <davem@davemloft.net>
In-Reply-To: <877gislbbk.fsf@nemi.mork.no>
References: <376FB829F3ECB542B825EAF4D8CA8A97013E8459E48B@CROEXCFWP03.gemalto.com>
	<877gislbbk.fsf@nemi.mork.no>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bjørn Mork <bjorn@mork.no>
Date: Tue, 21 May 2013 15:19:43 +0200

> Schmiedl Christian <Christian.Schmiedl@gemalto.com> writes:
> 
>> From: Hans-Christoph Schemmel <hans-christoph.schemmel@gemalto.com>
>>
>> Added support for Cinterion's PLxx WWAN Interface by adding QMI_FIXED_INTF with
>> Cinterion's Vendor ID as well as Product ID and WWAN Interface Number.
>>
>> Signed-off-by: Hans-Christoph Schemmel <hans-christoph.schemmel@gemalto.com>
>> Signed-off-by: Christian Schmiedl <christian.schmiedl@gemalto.com>
 ...
> Acked-by: Bjørn Mork <bjorn@mork.no>

Applied.
