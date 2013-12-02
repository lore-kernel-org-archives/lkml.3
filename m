Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753516Ab3LBXES (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 18:04:18 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:10148 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752190Ab3LBXEQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 18:04:16 -0500
X-AuditID: cbfee68e-b7f7e6d00000477d-a3-529d11eff6c4
From: Jingoo Han <jg1.han@samsung.com>
To: "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Rafael J. Wysocki'" <rafael.j.wysocki@intel.com>
References: <001501ceefb1$69c96820$3d5c3860$%han@samsung.com>
In-reply-to: <001501ceefb1$69c96820$3d5c3860$%han@samsung.com>
Subject: [PATCH 05/39] cpufreq: nforce2: remove DEFINE_PCI_DEVICE_TABLE macro
Date: Tue, 03 Dec 2013 08:04:14 +0900
Message-id: <001a01ceefb2$d21c4bd0$7654e370$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac7vsUc6neA2wWIVTNSB4ceFa5FjuwAAW00Q
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJIsWRmVeSWpSXmKPExsVy+t8zY933gnODDO6dYrFoXryezeLywkus
	Fpd3zWGzeLziLbsDi8fiPS+ZPPbPXcPu0bdlFaPH501yASxRXDYpqTmZZalF+nYJXBlPPv5k
	KzjNWnF+/3GWBsZbLF2MHBwSAiYSfas5uhg5gUwxiQv31rN1MXJxCAksY5Q4cms3K0zN63NO
	EPHpjBJTbx1lhXB+MUoc/fmJEaSbTUBN4suXw+wgtoiAqcTG91MYQZqZBaokbk8SAQkLCdhK
	TH+xmQkkzClgJ9H3qRYkLCzgK/Hl7zOwVSwCqhILXruDhHmBqqftbWSGsAUlfky+xwJiMwto
	SazfeZwJwpaX2LzmLTPEleoSj/7qQuw3kvh7bBY7RImIxL4X7xhBDpYQuMQuce7iAbAEi4CA
	xLfJh6ChICux6QAzJBQkJQ6uuMEygVFiFpLNs5BsnoVk8ywkKxYwsqxiFE0tSC4oTkovMtIr
	TswtLs1L10vOz93ECInGvh2MNw9YH2JMBlo/kVlKNDkfGM15JfGGxmZGFqYmpsZG5pZmpAkr
	ifMuepgUJCSQnliSmp2aWpBaFF9UmpNafIiRiYNTqoGRK/jDC/2m9R9vnBaPyOnjnavp9GG7
	2+HVjDGzPmj+OTdx5sxtOatdEjK5ZN/+2dP9d3OXrNHdNxM2SV3p7Pg+/fLL0yY6U8KVz9+J
	5Gf1SKpqyZ2wa8uVmE8+oc0GTLuCuqtPf114IItB7+WhiX5/dfV1mZ+5XhDpurv36b+G7aUZ
	YcKdn0q0lViKMxINtZiLihMBrwroTNwCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrGKsWRmVeSWpSXmKPExsVy+t9jQd33gnODDL6WWzQvXs9mcXnhJVaL
	y7vmsFk8XvGW3YHFY/Gel0we++euYffo27KK0ePzJrkAlqgGRpuM1MSU1CKF1Lzk/JTMvHRb
	Je/geOd4UzMDQ11DSwtzJYW8xNxUWyUXnwBdt8wcoJVKCmWJOaVAoYDE4mIlfTtME0JD3HQt
	YBojdH1DguB6jAzQQMI6xownH3+yFZxmrTi//zhLA+Mtli5GDg4JAROJ1+ecuhg5gUwxiQv3
	1rN1MXJxCAlMZ5SYeusoK4Tzi1Hi6M9PjCBVbAJqEl++HGYHsUUETCU2vp/CCDKIWaBK4vYk
	EZCwkICtxPQXm5lAwpwCdhJ9n2pBwsICvhJf/j5jBQmzCKhKLHjtDhLmBaqetreRGcIWlPgx
	+R4LiM0soCWxfudxJghbXmLzmrfMEBerSzz6qwux30ji77FZ7BAlIhL7XrxjnMAoNAvJpFlI
	Js1CMmkWkpYFjCyrGEVTC5ILipPSc430ihNzi0vz0vWS83M3MYJj/Zn0DsZVDRaHGAU4GJV4
	eB9snxMkxJpYVlyZe4hRgoNZSYS3k2dukBBvSmJlVWpRfnxRaU5q8SHGZKA/JzJLiSbnA9NQ
	Xkm8obGJmZGlkZmFkYm5OWnCSuK8B1utA4UE0hNLUrNTUwtSi2C2MHFwSjUwaulOCAtiWLTr
	mM9f5eC2M8Wr3C5HFOwNyjZqcuXe0X5cgT/8RsaEz8aLN7wQc7vWsXf6m7LmtH0nN7QlOD+f
	Uvbyo1PNvT01O3kETnyNvqF7c82r9eV3fbOi9F/uesH6+/VP1bXcjw9tc3h1Wdnlz7wli96f
	kC41DNvcElw1ZXcP4y+en5KfjyuxFGckGmoxFxUnAgDmN46tOQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't use DEFINE_PCI_DEVICE_TABLE macro, because this macro
is not preferred.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/cpufreq/cpufreq-nforce2.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/cpufreq/cpufreq-nforce2.c b/drivers/cpufreq/cpufreq-nforce2.c
index a05b876..353ccfa 100644
--- a/drivers/cpufreq/cpufreq-nforce2.c
+++ b/drivers/cpufreq/cpufreq-nforce2.c
@@ -379,7 +379,7 @@ static struct cpufreq_driver nforce2_driver = {
 };
 
 #ifdef MODULE
-static DEFINE_PCI_DEVICE_TABLE(nforce2_ids) = {
+static const struct pci_device_id nforce2_ids[] = {
 	{ PCI_VENDOR_ID_NVIDIA, PCI_DEVICE_ID_NVIDIA_NFORCE2 },
 	{}
 };
-- 
1.7.10.4


