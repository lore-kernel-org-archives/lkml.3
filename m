Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933733Ab3CMOUh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 10:20:37 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:53011 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932356Ab3CMOUe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 10:20:34 -0400
X-AuditID: cbfee68e-b7f946d000001e37-a2-51408b313f71
From: Seungwon Jeon <tgih.jun@samsung.com>
To: "'James Hogan'" <james.hogan@imgtec.com>, linux-mmc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "'Jaehoon Chung'" <jh80.chung@samsung.com>,
        "'Chris Ball'" <cjb@laptop.org>
References: <1363085034-9270-1-git-send-email-james.hogan@imgtec.com>
In-reply-to: <1363085034-9270-1-git-send-email-james.hogan@imgtec.com>
Subject: RE: [PATCH] mmc: dw_mmc: move host->data_offset init earlier
Date: Wed, 13 Mar 2013 23:20:32 +0900
Message-id: <002401ce1ff5$ec1daf20$c4590d60$%jun@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ks_c_5601-1987
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4fDpM04saslFihRwaRKmxmQU5CfQA5Zlpw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrIIsWRmVeSWpSXmKPExsVy+t8zQ13DbodAg/uH2S22v97IZvFu3gtm
	ixu/2lgtLu+aw2Zx5H8/owOrR8/OM4weh66sZfTo27KK0ePzJrkAligum5TUnMyy1CJ9uwSu
	jAcXGlgKPjBX9J15wNbAOIe5i5GTQ0LARGLlh4nsELaYxIV769m6GLk4hASWMUr8/N/OAlO0
	5SlIEUhiOqPEm6eLoZw/jBKbV6wGa2cT0JL4++YN2FgRAVeJ/slTwOLMAtkSx3ubgOIcQA2u
	EtdXh4CEOQXcJM7+XA5WLgwUnn37DztICYuAqsSWHZYgYV4BW4mNLw+zQtiCEj8m32OBmGgg
	8X5WHyuELS+xec1bsOkSAuoSj/7qQhxgJLHz+kGochGJfS/eMYJcLCFwjl2ic/8WJpAEi4CA
	xLfJh1ggemUlNh2AhomkxMEVN1gmMErMQrJ5FpLNs5BsnoVkxQJGllWMoqkFyQXFSelFRnrF
	ibnFpXnpesn5uZsYIdHZt4Px5gHrQ4zJQOsnMkuJJucDozuvJN7Q2MzIwtTE1NjI3NKMNGEl
	cV61FutAIYH0xJLU7NTUgtSi+KLSnNTiQ4xMHJxSDYxWH/ZyX1v6asGh6d23lh3akTWf56+f
	jfCBgy9rP65LsOZ7v6P9YZmd4Z59K84w8EzYfu1M6Cb7uYJazwRNvicWSs4vTFuhMOVZbnjz
	df4/f+ZvtgmxU2wtZLBZv69BOtU+as3O+OqVrrVTP27drMzzYcen/+FS3/z7pi/Ycl0txGq9
	8pHLvwKPKbEUZyQaajEXFScCAH/gnmbkAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHKsWRmVeSWpSXmKPExsVy+t9jQV3DbodAg53bmS22v97IZvFu3gtm
	ixu/2lgtLu+aw2Zx5H8/owOrR8/OM4weh66sZfTo27KK0ePzJrkAlqgGRpuM1MSU1CKF1Lzk
	/JTMvHRbJe/geOd4UzMDQ11DSwtzJYW8xNxUWyUXnwBdt8wcoMVKCmWJOaVAoYDE4mIlfTtM
	E0JD3HQtYBojdH1DguB6jAzQQMI6xowHFxpYCj4wV/SdecDWwDiHuYuRk0NCwERiy9OJ7BC2
	mMSFe+vZuhi5OIQEpjNKvHm6mB3C+cMosXnFarAqNgEtib9v3oB1iwi4SvRPngIWZxbIljje
	2wQU5wBqcJW4vjoEJMwp4CZx9udysHJhoPDs23/YQUpYBFQltuywBAnzCthKbHx5mBXCFpT4
	MfkeC8REA4n3s/pYIWx5ic1r3oJNlxBQl3j0VxfiACOJndcPQpWLSOx78Y5xAqPQLCSTZiGZ
	NAvJpFlIWhYwsqxiFE0tSC4oTkrPNdIrTswtLs1L10vOz93ECI79Z9I7GFc1WBxiFOBgVOLh
	lUizDxRiTSwrrsw9xCjBwawkwrs81yFQiDclsbIqtSg/vqg0J7X4EGMy0J8TmaVEk/OBaSmv
	JN7Q2MTMyNLIzMLIxNycNGElcd6DrdaBQgLpiSWp2ampBalFMFuYODilGhjTt7g7v52qubNr
	1ZtJSre8edWvHtv8cMK5zdJh5/NtlvuZ3H1888KWp4kdXH8u33QvPx1tfqC58XTUnYDPeZ4F
	Yd8NV7/udz/H/lm3ICROZP/mTrF7Mz4vKlQTF18lLpe+cEZve/5Xd78ZpvHH9qWIeN0vfpkj
	JvqfT+7/i1/FRZOn68nvOPVYiaU4I9FQi7moOBEA11uB1kEDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, March 12, 2013, James Hogan wrote:
> host->data_offset is initialised at the end of the probe function
> depending on the VERID register, and is used for PIO operations. Move
> this initialisation earlier, before IRQs or slots are initialised, to be
> sure that PIO won't occur prior to host->data_offset being initialised.
> 
> Signed-off-by: James Hogan <james.hogan@imgtec.com>
> Cc: Seungwon Jeon <tgih.jun@samsung.com>

Acked-by: Seungwon Jeon <tgih.jun@samsung.com>

