Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752983AbaCJJrJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 05:47:09 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:21922 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752651AbaCJJrC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 05:47:02 -0400
X-AuditID: cbfec7f5-b7fc96d000004885-43-531d8a157689
Message-id: <1394444820.4365.1.camel@AMDC1943>
Subject: Re: [PATCH 1/8] regulator: max1586: Remove regulator_dev pointer from
 state container
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Mark Brown <broonie@kernel.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Date: Mon, 10 Mar 2014 10:47:00 +0100
In-reply-to: <20140310092311.GF28112@sirena.org.uk>
References: <1394440371-29588-1-git-send-email-k.kozlowski@samsung.com>
 <20140310092311.GF28112@sirena.org.uk>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.2.3-0ubuntu6
Content-transfer-encoding: 7bit
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprPLMWRmVeSWpSXmKPExsVy+t/xy7qiXbLBBp8e8lhMffiEzeLblQ4m
	i8u75rA5MHvsnHWX3WPTqk42j8+b5AKYo7hsUlJzMstSi/TtErgy1i1czFLwhLni2aW1bA2M
	bcxdjJwcEgImEhffX4GyxSQu3FvP1sXIxSEksJRRYtqx00wQzmdGiZ5TIFUcHLwCehLzl+WA
	NAgLJEj8/XacBcRmEzCW2Lx8CRuILSKgLHH1+16wOLOAq0TfvM3sIDaLgKrEtTMLwOKcIPV7
	XoLZQgIFEsunnIKqV5eYNG8R1EFKErvbO9kh4vISm9e8BYvzCghK/Jh8j2UCo8AsJC2zkJTN
	QlK2gJF5FaNoamlyQXFSeq6RXnFibnFpXrpecn7uJkZIoH7dwbj0mNUhRgEORiUe3gNvZYKF
	WBPLiitzDzFKcDArifA+bJUNFuJNSaysSi3Kjy8qzUktPsTIxMEp1cBYolXla7JJrlkn+o9/
	aPGEO6eT3zKHvn6rzv/tpUqjmt6qu/1qSxkLPSpqdKWk5/LJhYl2n6nWnnsn9vOdQ96XzJJ0
	px7X4//Hv6vP1EprQuKth+eWe55murpOzOjv5p8H9nqHSF4L7cxQU0/aEfJyi3kaj4NW8auJ
	cqUeyxbO6Gl8tegCz3ElluKMREMt5qLiRADY7rz4MgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-03-10 at 09:23 +0000, Mark Brown wrote:
> On Mon, Mar 10, 2014 at 09:32:44AM +0100, Krzysztof Kozlowski wrote:
> > Don't store pointer to regulator_dev returned by
> > devm_regulator_register() in state container. It isn't used anywhere
> > outside of max1586_pmic_probe() function.
> 
> Applied, thanks.

Thanks! However I missed one cleanup related to it, so please apply also
next patch (they could be squashed if you want to).

Best regards,
Krzysztof

