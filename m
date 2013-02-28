Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754760Ab3B1Iob (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 03:44:31 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:21642 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754581Ab3B1Io1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 03:44:27 -0500
X-AuditID: cbfee68e-b7fa46d00000627e-08-512f18ea0275
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <00a501ce158e$ef171610$cd454230$%han@samsung.com>
In-reply-to: <00a501ce158e$ef171610$cd454230$%han@samsung.com>
Subject: [PATCH 14/19] rtc: msm6242: remove erroneous __init/__exit annotations
Date: Thu, 28 Feb 2013 17:44:26 +0900
Message-id: <00b201ce158f$d0c178d0$72446a70$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4Vju7DHmrOxtsNRmyyH1DU6RVYuAAANJAQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrAIsWRmVeSWpSXmKPExsVy+t8zA93XEvqBBhPaGS0u75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAldGU/ds1oIJ3BVd558zNTAu4exi5OSQEDCR+H7xDiOELSZx4d56
	ti5GLg4hgWWMEi92z2WDKXqy/ioTRGIRo8SWjVOhnNlMEi0H+phBqtgE1CS+fDnM3sXIwSEi
	oC/R1qIBUsMs0MsocaZ3NztIjZCArcSxtjYWEJtTwE7i99OjrCC2sIC/xIKda8DOYBFQlVi0
	YCYTiM0LVH/h0TIWCFtQ4sfke2A2s4CWxPqdx5kgbHmJzWveMoPslRBQl3j0VxckLCJgJDHt
	5nNWiBIRiX0v3jGC3CMhsIpdoufFVahdAhLfJh9igeiVldh0gBniYUmJgytusExglJiFZPMs
	JJtnIdk8C8mKBYwsqxhFUwuSC4qT0ouM9IoTc4tL89L1kvNzNzFCYqtvB+PNA9aHGJOB1k9k
	lhJNzgfGZl5JvKGxsYmZiamJuaWpuSlpwkrivPKXZAKFBNITS1KzU1MLUovii0pzUosPMTJx
	cEo1MEYJ37Hk2vzNy1co0upwhobk843z/k15cpnb36FP5nrCrS8l6zLMOfUXn9v95IKscNzv
	XEFLxVvv/u5kyk25u5HX+Vf8rQMHktYeeyIRF/uCO2Z6wMFZ/oIbgg0myjLpXWc1ZfiW7O4a
	aMi5UXTnkmL/Djlv2/pPgS0Xtti2sHCzT8uX5BH9psRSnJFoqMVcVJwIADCORzfDAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplleLIzCtJLcpLzFFi42I5/e+xgO4rCf1AgznTzS0u75rD5sDo8XmT
	XABjVAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7Q
	VCWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYR1jRlP3bNaCCdwVXeefMzUw
	LuHsYuTkkBAwkXiy/ioThC0mceHeerYuRi4OIYFFjBJbNk5lgnBmM0m0HOhjBqliE1CT+PLl
	MHsXIweHiIC+RFuLBkgNs0Avo8SZ3t3sIDVCArYSx9raWEBsTgE7id9Pj7KC2MIC/hILdq5h
	BLFZBFQlFi2YCbaZF6j+wqNlLBC2oMSPyffAbGYBLYn1O48zQdjyEpvXvGUG2SshoC7x6K8u
	SFhEwEhi2s3nrBAlIhL7XrxjnMAoNAvJpFlIJs1CMmkWkpYFjCyrGEVTC5ILipPSc430ihNz
	i0vz0vWS83M3MYIj95n0DsZVDRaHGAU4GJV4eDtM9AKFWBPLiitzDzFKcDArifC68OsHCvGm
	JFZWpRblxxeV5qQWH2JMBnp0IrOUaHI+MKnklcQbGpuYGVkamVkYmZibkyasJM7LeOpJgJBA
	emJJanZqakFqEcwWJg5OqQbGzdLXNVeInPGNPprZ9UHbxojNYD/Du/gzAsYFyuc5WYpbNF7+
	eL201GvJBPV9cjYHy6/6ZwZ1mHrkGeSrrHh6ybxcfQ9HYIONfdAWT7ldIQXv/zsvOrigrPb2
	ju7C+0YnnP7xLVt/2+Cx7p2tSUx8lknNsutuaqyuTlCtie2aOz+sk8HjYr4SS3FGoqEWc1Fx
	IgBbn8DAIAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__init/__exit annotations for probe()/remove() are supposed to be
__devinit/__devexit, because __init/__exit for probe()/remove()
are not correct. However, __devinit/__devexit are not used,
because CONFIG_HOTPLUG was removed. Thus, these annotations
should be removed.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/rtc-msm6242.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/rtc/rtc-msm6242.c b/drivers/rtc/rtc-msm6242.c
index fcb113c..b1d432f 100644
--- a/drivers/rtc/rtc-msm6242.c
+++ b/drivers/rtc/rtc-msm6242.c
@@ -194,7 +194,7 @@ static const struct rtc_class_ops msm6242_rtc_ops = {
 	.set_time	= msm6242_set_time,
 };
 
-static int __init msm6242_rtc_probe(struct platform_device *dev)
+static int msm6242_rtc_probe(struct platform_device *dev)
 {
 	struct resource *res;
 	struct msm6242_priv *priv;
@@ -234,7 +234,7 @@ out_free_priv:
 	return error;
 }
 
-static int __exit msm6242_rtc_remove(struct platform_device *dev)
+static int msm6242_rtc_remove(struct platform_device *dev)
 {
 	struct msm6242_priv *priv = platform_get_drvdata(dev);
 
@@ -249,7 +249,7 @@ static struct platform_driver msm6242_rtc_driver = {
 		.name	= "rtc-msm6242",
 		.owner	= THIS_MODULE,
 	},
-	.remove	= __exit_p(msm6242_rtc_remove),
+	.remove	= msm6242_rtc_remove,
 };
 
 static int __init msm6242_rtc_init(void)
-- 
1.7.2.5


