Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752524AbaHSLNy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 07:13:54 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:24654 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751528AbaHSLNv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 07:13:51 -0400
X-AuditID: cbfee68f-b7fa26d0000039a0-9d-53f3316d5638
Date: Tue, 19 Aug 2014 20:13:49 +0900
From: Inha Song <ideal.song@samsung.com>
To: broonie@kernel.org
Cc: alsa-devel@alsa-project.org, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org, lee.jones@linaro.org,
        ckeepax@opensource.wolfsonmicro.com, lgirdwood@gmail.com,
        sameo@linux.intel.com, devicetree@vger.kernel.org,
        galak@codeaurora.org, ijc+devicetree@hellion.org.uk,
        mark.rutland@arm.com, pawel.moll@arm.com, robh+dt@kernel.org,
        cw00.choi@samsung.com
Subject: [alsa-devel] [PATCH v4 0/2] mfd: arizona: add support for INn_MODE
 register control using platform data
Message-id: <20140819201349.18f4233f@songinha-Samsung-DeskTop-System>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNIsWRmVeSWpSXmKPExsWyRsSkUDfX8HOwwaPZJhZXLh5ispj68Amb
	xb8pN9gtrn95zmox/8g5Vov+NwtZLc69Wslocf/rUUaLb1c6mCwu75rDZrH0+kUmi+Vv/7NZ
	TJi+lsWide8RdovT3awO/B4bPjexeayZt4bR43JfL5PHzll32T1WLv/C5rFpVSebx51re9g8
	5p0M9Hg58TebR9+WVYwenzfJBXBHcdmkpOZklqUW6dslcGWcP/SFqWADW8WWt0/YGxgbWbsY
	OTkkBEwkem6+ZoewxSQu3FvP1sXIxSEksJRRYuXWu3BFl+/NZYdITGeUWPX8JwuE088kcffY
	AbB2FgFViRltB5hAbDYBDYnvnzczg9giQGNvz+lkBmlgFvjJJNG84glYQligSOLlzuVAKzg4
	eAVcJXa9EYLYZiOxeuc6sBJeAUGJH5PvsYDYzAJaEpu3NbFC2PISm9e8BZspITCTQ+Lc3ROM
	EEcISHybfIgFZKaEgKzEpgPMEDMlJQ6uuMEygVFkFpKxs5CMnYVk7AJG5lWMoqkFyQXFSelF
	xnrFibnFpXnpesn5uZsYgRF9+t+z/h2Mdw9YH2JMBlo5kVlKNDkfmBDySuINjc2MLExNTI2N
	zC3NSBNWEue9/zApSEggPbEkNTs1tSC1KL6oNCe1+BAjEwenVANj5esn+xWNzuqsC9vJbtDS
	uFfg4Ma/P7/v8ep7ybw6Yc0cV7kTqv6u9/LjeBVOffTndnCLULn69sHstUyhu+9ujpjw7/IS
	joM8V9WtPROrAlqiV2x74bAg+8WGLVf1jHapLZPz2CKcw9p7p8OuZMND46RJJbxv9qdyBU7q
	Pududb358TTH8081lViKMxINtZiLihMBMyGla/4CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprFKsWRmVeSWpSXmKPExsVy+t9jQd1cw8/BBm/na1tcuXiIyWLqwyds
	Fv+m3GC3uP7lOavF/CPnWC363yxktTj3aiWjxf2vRxktvl3pYLK4vGsOm8XS6xeZLJa//c9m
	MWH6WhaL1r1H2C1Od7M68Hts+NzE5rFm3hpGj8t9vUweO2fdZfdYufwLm8emVZ1sHneu7WHz
	mHcy0OPlxN9sHn1bVjF6fN4kF8Ad1cBok5GamJJapJCal5yfkpmXbqvkHRzvHG9qZmCoa2hp
	Ya6kkJeYm2qr5OIToOuWmQP0i5JCWWJOKVAoILG4WEnfDtOE0BA3XQuYxghd35AguB4jAzSQ
	sIYx4/yhL0wFG9gqtrx9wt7A2MjaxcjJISFgInH53lx2CFtM4sK99WxdjFwcQgLTGSVWPf/J
	AuH0M0ncPXYArIpFQFViRtsBJhCbTUBD4vvnzcwgtghQ9+05ncwgDcwCP5kkmlc8AUsICxRJ
	vNy5HGgdBwevgKvErjdCENtsJFbvXAdWwisgKPFj8j0WEJtZQEti87YmVghbXmLzmrfMExj5
	ZiEpm4WkbBaSsgWMzKsYRVMLkguKk9JzDfWKE3OLS/PS9ZLzczcxgtPFM6kdjCsbLA4xCnAw
	KvHwKnz5GCzEmlhWXJl7iFGCg1lJhLdD+nOwEG9KYmVValF+fFFpTmrxIUZToK8nMkuJJucD
	U1leSbyhsYmZkaWRuaGFkbG5kjjvgVbrQCGB9MSS1OzU1ILUIpg+Jg5OqQbG7R5hbT63Z4We
	F/MUnVsawLv0sInvTA8W6V+nOmu2xV6frrdQqfsWm87uTaynlfJWMaUrLz87TWJX1/ZNV96p
	5R8r59DVjWFz0Hi/MS+jduIqH8EC+eKTWxa8jzbyf/hg1SWRxp0NEtMPn0gOZLpZlrajbNXX
	C5MPVPB6uB010yhy5w17dc9eiaU4I9FQi7moOBEAAqO7rC0DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series add support for INn_MODE register control using platform data.
Each input signal path can be configurated either as a Analogue or Digital using
the INn_MODE registers.

Changes for v4
- Update document content for more clarity

Changes for v3
- Change to use of_property_read_u32_array
- Fix a few typos
- Update commit message

Changes for v2
- Change to support
- Update commit message
- Update document content for more clarity

Inha Song (2):
  mfd: arizona: Add support for INn_Mode register control
  mfd: arizona: Update DT binding to support INn_MODE init_data

 Documentation/devicetree/bindings/mfd/arizona.txt | 7 +++++++
 drivers/mfd/arizona-core.c                        | 8 +++++++-
 2 files changed, 14 insertions(+), 1 deletion(-)

-- 
2.0.0.390.gcb682f8
