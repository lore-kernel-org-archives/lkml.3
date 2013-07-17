Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756974Ab3GQTIH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 15:08:07 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:63776 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756861Ab3GQTIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 15:08:04 -0400
From: Yacine Belkadi <yacine.belkadi.1@gmail.com>
To: Daniel Borkmann <dborkman@redhat.com>,
        John Stultz <john.stultz@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Liu Ying <Ying.Liu@freescale.com>
Cc: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        yacine.belkadi.1@gmail.com
Subject: [PATCH] ktime: fix some scripts/kernel-doc warnings
Date: Wed, 17 Jul 2013 21:07:39 +0200
Message-Id: <1374088059-2225-1-git-send-email-yacine.belkadi.1@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When building the htmldocs (in verbose mode), scripts/kernel-doc reports the
following type of warnings:
Warning(include/linux/ktime.h:75): No description found for return value of
'ktime_set'

Fix them by using a "Return:" section to describe the return values.
(Also apply some minor reformatting along the way.)

Signed-off-by: Yacine Belkadi <yacine.belkadi.1@gmail.com>

---

Applied to d2b4a646717153a1a180b64d4a8464054dbd700e

 include/linux/ktime.h |   28 +++++++++++++++-------------
 1 file changed, 15 insertions(+), 13 deletions(-)

diff --git a/include/linux/ktime.h b/include/linux/ktime.h
index fc66b30..6e89f28 100644
--- a/include/linux/ktime.h
+++ b/include/linux/ktime.h
@@ -69,7 +69,7 @@ typedef union ktime ktime_t;		/* Kill this */
  * @secs:	seconds to set
  * @nsecs:	nanoseconds to set
  *
- * Return the ktime_t representation of the value
+ * Return: The ktime_t representation of the value.
  */
 static inline ktime_t ktime_set(const long secs, const unsigned long nsecs)
 {
@@ -151,7 +151,7 @@ static inline ktime_t ktime_set(const long secs, const unsigned long nsecs)
  * @lhs:	minuend
  * @rhs:	subtrahend
  *
- * Returns the remainder of the subtraction
+ * Return: The remainder of the subtraction.
  */
 static inline ktime_t ktime_sub(const ktime_t lhs, const ktime_t rhs)
 {
@@ -169,7 +169,7 @@ static inline ktime_t ktime_sub(const ktime_t lhs, const ktime_t rhs)
  * @add1:	addend1
  * @add2:	addend2
  *
- * Returns the sum of @add1 and @add2.
+ * Return: The sum of @add1 and @add2.
  */
 static inline ktime_t ktime_add(const ktime_t add1, const ktime_t add2)
 {
@@ -195,7 +195,7 @@ static inline ktime_t ktime_add(const ktime_t add1, const ktime_t add2)
  * @kt:		addend
  * @nsec:	the scalar nsec value to add
  *
- * Returns the sum of @kt and @nsec in ktime_t format
+ * Return: The sum of @kt and @nsec in ktime_t format.
  */
 extern ktime_t ktime_add_ns(const ktime_t kt, u64 nsec);
 
@@ -204,7 +204,7 @@ extern ktime_t ktime_add_ns(const ktime_t kt, u64 nsec);
  * @kt:		minuend
  * @nsec:	the scalar nsec value to subtract
  *
- * Returns the subtraction of @nsec from @kt in ktime_t format
+ * Return: The subtraction of @nsec from @kt in ktime_t format.
  */
 extern ktime_t ktime_sub_ns(const ktime_t kt, u64 nsec);
 
@@ -212,7 +212,7 @@ extern ktime_t ktime_sub_ns(const ktime_t kt, u64 nsec);
  * timespec_to_ktime - convert a timespec to ktime_t format
  * @ts:		the timespec variable to convert
  *
- * Returns a ktime_t variable with the converted timespec value
+ * Return: A ktime_t variable with the converted timespec value.
  */
 static inline ktime_t timespec_to_ktime(const struct timespec ts)
 {
@@ -224,7 +224,7 @@ static inline ktime_t timespec_to_ktime(const struct timespec ts)
  * timeval_to_ktime - convert a timeval to ktime_t format
  * @tv:		the timeval variable to convert
  *
- * Returns a ktime_t variable with the converted timeval value
+ * Return: A ktime_t variable with the converted timeval value.
  */
 static inline ktime_t timeval_to_ktime(const struct timeval tv)
 {
@@ -237,7 +237,7 @@ static inline ktime_t timeval_to_ktime(const struct timeval tv)
  * ktime_to_timespec - convert a ktime_t variable to timespec format
  * @kt:		the ktime_t variable to convert
  *
- * Returns the timespec representation of the ktime value
+ * Return: The timespec representation of the ktime value.
  */
 static inline struct timespec ktime_to_timespec(const ktime_t kt)
 {
@@ -249,7 +249,7 @@ static inline struct timespec ktime_to_timespec(const ktime_t kt)
  * ktime_to_timeval - convert a ktime_t variable to timeval format
  * @kt:		the ktime_t variable to convert
  *
- * Returns the timeval representation of the ktime value
+ * Return: The timeval representation of the ktime value.
  */
 static inline struct timeval ktime_to_timeval(const ktime_t kt)
 {
@@ -262,7 +262,7 @@ static inline struct timeval ktime_to_timeval(const ktime_t kt)
  * ktime_to_ns - convert a ktime_t variable to scalar nanoseconds
  * @kt:		the ktime_t variable to convert
  *
- * Returns the scalar nanoseconds representation of @kt
+ * Return: The scalar nanoseconds representation of @kt.
  */
 static inline s64 ktime_to_ns(const ktime_t kt)
 {
@@ -276,7 +276,9 @@ static inline s64 ktime_to_ns(const ktime_t kt)
  * @cmp1:	comparable1
  * @cmp2:	comparable2
  *
- * Compare two ktime_t variables, returns 1 if equal
+ * Compare two ktime_t variables.
+ *
+ * Return: 1 if equal.
  */
 static inline int ktime_equal(const ktime_t cmp1, const ktime_t cmp2)
 {
@@ -288,7 +290,7 @@ static inline int ktime_equal(const ktime_t cmp1, const ktime_t cmp2)
  * @cmp1:	comparable1
  * @cmp2:	comparable2
  *
- * Returns ...
+ * Return: ...
  *   cmp1  < cmp2: return <0
  *   cmp1 == cmp2: return 0
  *   cmp1  > cmp2: return >0
@@ -337,7 +339,7 @@ extern ktime_t ktime_add_safe(const ktime_t lhs, const ktime_t rhs);
  * @kt:		the ktime_t variable to convert
  * @ts:		the timespec variable to store the result in
  *
- * Returns true if there was a successful conversion, false if kt was 0.
+ * Return: %true if there was a successful conversion, %false if kt was 0.
  */
 static inline __must_check bool ktime_to_timespec_cond(const ktime_t kt,
 						       struct timespec *ts)
-- 
1.7.10.4

