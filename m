Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752850Ab3LBXD1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 18:03:27 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:9962 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751043Ab3LBXDY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 18:03:24 -0500
X-AuditID: cbfee68e-b7f7e6d00000477d-e0-529d11bb22e9
From: Jingoo Han <jg1.han@samsung.com>
To: "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Dave Airlie'" <airlied@redhat.com>
References: <001501ceefb1$69c96820$3d5c3860$%han@samsung.com>
In-reply-to: <001501ceefb1$69c96820$3d5c3860$%han@samsung.com>
Subject: [PATCH 04/39] char: amd64-agp: remove DEFINE_PCI_DEVICE_TABLE macro
Date: Tue, 03 Dec 2013 08:03:23 +0900
Message-id: <001901ceefb2$b35a2690$1a0e73b0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac7vsUc6neA2wWIVTNSB4ceFa5FjuwAATB/g
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLIsWRmVeSWpSXmKPExsVy+t8zY93dgnODDN6e0bC4emsBk0Xz4vVs
	FpcXXmK1uLxrDpsDi8f+uWvYPd7vu8rm0bdlFaPH501yASxRXDYpqTmZZalF+nYJXBmPX+1k
	LrjDWjF3zyLWBsZXLF2MnBwSAiYS7SsPMUHYYhIX7q1n62Lk4hASWMYo0fb+GCNM0f7ly5gh
	EtMZJW6v2wFV9YtR4v+ea2wgVWwCahJfvhxmB7FFBEwlNr6fAtbNLJAlcb3/MlhcSMBWYvqL
	zUDrODg4Bewk+j7VgoSFBXwkfu+YCVbOIqAqcXv6fjCbF6j8zeI3TBC2oMSPyfdYIEZqSazf
	eZwJwpaX2LzmLTPISAkBdYlHf3UhLjCSmHJoD1SJiMS+F+8YQU6WEDjHLvHj7yt2iF0CEt8m
	H2KB6JWV2HSAGeJfSYmDK26wTGCUmIVk8ywkm2ch2TwLyYoFjCyrGEVTC5ILipPSi4z0ihNz
	i0vz0vWS83M3MUKism8H480D1ocYk4HWT2SWEk3OB0Z1Xkm8obGZkYWpiamxkbmlGWnCSuK8
	ix4mBQkJpCeWpGanphakFsUXleakFh9iZOLglGpgLN/w2zB82e35M42eR2wI+/hh5crlk6oS
	Nkbtq532aEv+Ak6JI+sTko7t3f1sdv/aP5GhZgG+vm/MX1h9L12/dEt9k3bhLJ7AO3OXLb69
	2a9o5QXWif19SfbnZGulZp25sZVDWqOzPLViWzHvkjqri1+tza4vOe7xZVXHlpoZmQ+3Vj5N
	+fjK6pkSS3FGoqEWc1FxIgB8Gk7U4AIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrFKsWRmVeSWpSXmKPExsVy+t9jQd3dgnODDE79ULG4emsBk0Xz4vVs
	FpcXXmK1uLxrDpsDi8f+uWvYPd7vu8rm0bdlFaPH501yASxRDYw2GamJKalFCql5yfkpmXnp
	tkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUA7lRTKEnNKgUIBicXFSvp2mCaEhrjp
	WsA0Ruj6hgTB9RgZoIGEdYwZj1/tZC64w1oxd88i1gbGVyxdjJwcEgImEvuXL2OGsMUkLtxb
	z9bFyMUhJDCdUeL2uh1Qzi9Gif97rrGBVLEJqEl8+XKYHcQWETCV2Ph+CiOIzSyQJXG9/zJY
	XEjAVmL6i81MXYwcHJwCdhJ9n2pBwsICPhK/d8wEK2cRUJW4PX0/mM0LVP5m8RsmCFtQ4sfk
	eywQI7Uk1u88zgRhy0tsXvOWGWSkhIC6xKO/uhAXGElMObQHqkREYt+Ld4wTGIVmIZk0C8mk
	WUgmzULSsoCRZRWjaGpBckFxUnquoV5xYm5xaV66XnJ+7iZGcMw/k9rBuLLB4hCjAAejEg/v
	g+1zgoRYE8uKK3MPMUpwMCuJ8HbyzA0S4k1JrKxKLcqPLyrNSS0+xJgM9OhEZinR5HxgOsor
	iTc0NjEzsjQyszAyMTcnTVhJnPdAq3WgkEB6YklqdmpqQWoRzBYmDk6pBkZrLb6vaz0ffe83
	DO+f18d77M+EplPJ2S+uK1kK7HvXeY5tevKkPfeDdrSYztL9zb57zZGsrx4bu57dWHihas/T
	+XMmzuEzefbL8N71J/sy9y3yO/x8Ps+h2th7ZccvG25d7cW97cildMOjqorOi43VZp/m0wlc
	FbN58sqLVkfWRogu45iz8HJRvxJLcUaioRZzUXEiAIFL6+I9AwAA
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
 drivers/char/agp/amd64-agp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/agp/amd64-agp.c b/drivers/char/agp/amd64-agp.c
index d79d692..896413b 100644
--- a/drivers/char/agp/amd64-agp.c
+++ b/drivers/char/agp/amd64-agp.c
@@ -735,7 +735,7 @@ static struct pci_device_id agp_amd64_pci_table[] = {
 
 MODULE_DEVICE_TABLE(pci, agp_amd64_pci_table);
 
-static DEFINE_PCI_DEVICE_TABLE(agp_amd64_pci_promisc_table) = {
+static const struct pci_device_id agp_amd64_pci_promisc_table[] = {
 	{ PCI_DEVICE_CLASS(0, 0) },
 	{ }
 };
-- 
1.7.10.4


