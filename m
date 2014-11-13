Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932265AbaKMIth (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 03:49:37 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:51266 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932187AbaKMIte (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 03:49:34 -0500
X-AuditID: cbfee68f-f791c6d000004834-80-5464709dc5f7
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: pratikp@codeaurora.org, mathieu.poirier@linaro.org,
        gregkh@linuxfoundation.org, Pankaj Dubey <pankaj.dubey@samsung.com>
Subject: [PATCH 2/3] coresight: fixed comments in coresight.h
Date: Thu, 13 Nov 2014 14:12:48 +0530
Message-id: <1415868169-13325-3-git-send-email-pankaj.dubey@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1415868169-13325-1-git-send-email-pankaj.dubey@samsung.com>
References: <1415868169-13325-1-git-send-email-pankaj.dubey@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGLMWRmVeSWpSXmKPExsWyRsSkWnduQUqIwdlZihbNi9ezWWx6fI3V
	4vKuOWwWW/ccYLJYtPULu8W3++YObB6X+3qZPO5c28PmsX/uGnaPzUvqPfq2rGL0+LxJLoAt
	issmJTUnsyy1SN8ugSvjyIo+9oINghUbJmxlb2CcxtfFyMkhIWAiMenOI2YIW0ziwr31bCC2
	kMBSRon5n2q7GDnAar4/Su5i5AIKL2KU+HHpOzOEM4FJYvGWl6wgDWwCuhJP3s8FGyQi4CZx
	o7GDCcRmFqiVOLFuGVhcWMBW4u/UhWALWARUJX4duwHWyyvgIXHi0jd2iGUKEnMm2YCEOQU8
	JS4d+8EKcY+HxMlNC1gh7pzOLtG7lANijIDEt8mHWCBaZSU2HYB6RVLi4IobLBMYhRcwMqxi
	FE0tSC4oTkovMtYrTswtLs1L10vOz93ECAzu0/+e9e9gvHvA+hCjAAejEg/vC5aUECHWxLLi
	ytxDjKZAGyYyS4km5wNjKK8k3tDYzMjC1MTU2Mjc0kxJnHeh1M9gIYH0xJLU7NTUgtSi+KLS
	nNTiQ4xMHJxSDYxWQlLSXZPWVHF/uq6ROf+e8nfV+mCvyg/B1z9eELJof/ew3H8Zr6KjY8Er
	i0nKnqFakbt/Ovn0pp5LfG1drFk592aLb+TxP9pPj7TUdQU2/P+6Xzr0MtNzC9M5VneOJ/Je
	9fh4zIP337v13yrLj+6acO7a/Gu1om+lj+x6/PHWpLeGETKHH4opsRRnJBpqMRcVJwIAxWfA
	t2kCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrEIsWRmVeSWpSXmKPExsVy+t9jAd25BSkhBqdOSFg0L17PZrHp8TVW
	i8u75rBZbN1zgMli0dYv7Bbf7ps7sHlc7utl8rhzbQ+bx/65a9g9Ni+p9+jbsorR4/MmuQC2
	qAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zBygK5QU
	yhJzSoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUYGaCBhDWMGUdW9LEXbBCs2DBhK3sD4zS+
	LkYODgkBE4nvj5K7GDmBTDGJC/fWs3UxcnEICSxilPhx6TszhDOBSWLxlpesIFVsAroST97P
	ZQaxRQTcJG40djCB2MwCtRIn1i0DiwsL2Er8nbqQDcRmEVCV+HXsBlgvr4CHxIlL39ghFitI
	zJlkAxLmFPCUuHTsB1iJEFDJyU0LWCcw8i5gZFjFKJpakFxQnJSea6RXnJhbXJqXrpecn7uJ
	ERw/z6R3MK5qsDjEKMDBqMTD+4IlJUSINbGsuDL3EKMEB7OSCG+TDlCINyWxsiq1KD++qDQn
	tfgQoynQUROZpUST84GxnVcSb2hsYm5qbGppYmFiZqkkznuw1TpQSCA9sSQ1OzW1ILUIpo+J
	g1OqgVHu0ryXM9uUslaF87+TVS9rYNDe8fO9w0xxv8NBmy59DWLcvfqoy3e7PsPnN3ZwTJPQ
	bkmsfGsqd6BwWeNpg3Uh6xfUHPp741bdfYkHbdyO/JWzJtXzJq74NXdR+lSxpTrXhNMWt6xL
	KF53yFLnPfPVs2c2a3FmOeWyy89/JbZm/q/PDJI5DhlKLMUZiYZazEXFiQCssB+qtQIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fixes following minor issues in code comments in coresight.h
- typo %s/enpoint/endpoint
- alignment of comment section for struct coresight_desc
- correction of comment for struct coresight_connection and
  struct coresight_device.

Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
---
 include/linux/coresight.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/coresight.h b/include/linux/coresight.h
index bdde419..5d3c543 100644
--- a/include/linux/coresight.h
+++ b/include/linux/coresight.h
@@ -87,7 +87,7 @@ struct coresight_dev_subtype {
  * @cpu:	the CPU a source belongs to. Only applicable for ETM/PTMs.
  * @name:	name of the component as shown under sysfs.
  * @nr_inport:	number of input ports for this component.
- * @outports:	list of remote enpoint port number.
+ * @outports:	list of remote endpoint port number.
  * @child_names:name of all child components connected to this device.
  * @child_ports:child component port number the current component is
 		connected  to.
@@ -113,7 +113,7 @@ struct coresight_platform_data {
 		by @coresight_ops.
  * @pdata:	platform data collected from DT.
  * @dev:	The device entity associated to this component.
- * @groups	:operations specific to this component. These will end up
+ * @groups:	operations specific to this component. These will end up
 		in the component's sysfs sub-directory.
  */
 struct coresight_desc {
@@ -127,7 +127,6 @@ struct coresight_desc {
 
 /**
  * struct coresight_connection - representation of a single connection
- * @ref_count:	keeping count a port' references.
  * @outport:	a connection's output port number.
  * @chid_name:	remote component's name.
  * @child_port:	remote component's port number @output is connected to.
@@ -143,6 +142,7 @@ struct coresight_connection {
 
 /**
  * struct coresight_device - representation of a device as used by the framework
+ * @conns:	array of coresight_connections associated to this component.
  * @nr_inport:	number of input port associated to this component.
  * @nr_outport:	number of output port associated to this component.
  * @type:	as defined by @coresight_dev_type.
-- 
1.7.9.5

