Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756516AbaGHTro (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 15:47:44 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54052 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755658AbaGHTIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 15:08:38 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Geert Uytterhoeven" <geert+renesas@glider.be>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Date: Tue, 08 Jul 2014 20:01:50 +0100
Message-ID: <lsq.1404846110.790574856@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 121/125] Documentation: Update stable address in
 Chinese and Japanese translations
In-Reply-To: <lsq.1404846109.699842714@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.61-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Geert Uytterhoeven <geert+renesas@glider.be>

commit 98b0f811aade1b7c6e7806c86aa0befd5919d65f upstream.

The English and Korean translations were updated, the Chinese and Japanese
weren't.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 Documentation/ja_JP/HOWTO                   | 2 +-
 Documentation/ja_JP/stable_kernel_rules.txt | 6 +++---
 Documentation/zh_CN/HOWTO                   | 2 +-
 Documentation/zh_CN/stable_kernel_rules.txt | 2 +-
 4 files changed, 6 insertions(+), 6 deletions(-)

--- a/Documentation/ja_JP/HOWTO
+++ b/Documentation/ja_JP/HOWTO
@@ -315,7 +315,7 @@
 もし、2.6.x.y カーネルが存在しない場合には、番号が一番大きい 2.6.x が
 最新の安定版カーネルです。
 
-2.6.x.y は "stable" チーム <stable@kernel.org> でメンテされており、必
+2.6.x.y は "stable" チーム <stable@vger.kernel.org> でメンテされており、必
 要に応じてリリースされます。通常のリリース期間は 2週間毎ですが、差し迫っ
 た問題がなければもう少し長くなることもあります。セキュリティ関連の問題
 の場合はこれに対してだいたいの場合、すぐにリリースがされます。
--- a/Documentation/ja_JP/stable_kernel_rules.txt
+++ b/Documentation/ja_JP/stable_kernel_rules.txt
@@ -50,16 +50,16 @@
 
 -stable ツリーにパッチを送付する手続き-
 
- - 上記の規則に従っているかを確認した後に、stable@kernel.org にパッチ
+ - 上記の規則に従っているかを確認した後に、stable@vger.kernel.org にパッチ
    を送る。
  - 送信者はパッチがキューに受け付けられた際には ACK を、却下された場合
    には NAK を受け取る。この反応は開発者たちのスケジュールによって、数
    日かかる場合がある。
  - もし受け取られたら、パッチは他の開発者たちと関連するサブシステムの
    メンテナーによるレビューのために -stable キューに追加される。
- - パッチに stable@kernel.org のアドレスが付加されているときには、それ
+ - パッチに stable@vger.kernel.org のアドレスが付加されているときには、それ
    が Linus のツリーに入る時に自動的に stable チームに email される。
- - セキュリティパッチはこのエイリアス (stable@kernel.org) に送られるべ
+ - セキュリティパッチはこのエイリアス (stable@vger.kernel.org) に送られるべ
    きではなく、代わりに security@kernel.org のアドレスに送られる。
 
 レビューサイクル-
--- a/Documentation/zh_CN/HOWTO
+++ b/Documentation/zh_CN/HOWTO
@@ -237,7 +237,7 @@
 如果没有2.6.x.y版本内核存在，那么最新的2.6.x版本内核就相当于是当前的稳定
 版内核。
 
-2.6.x.y版本由“稳定版”小组（邮件地址<stable@kernel.org>）维护，一般隔周发
+2.6.x.y版本由“稳定版”小组（邮件地址<stable@vger.kernel.org>）维护，一般隔周发
 布新版本。
 
 内核源码中的Documentation/stable_kernel_rules.txt文件具体描述了可被稳定
--- a/Documentation/zh_CN/stable_kernel_rules.txt
+++ b/Documentation/zh_CN/stable_kernel_rules.txt
@@ -42,7 +42,7 @@
 
 向稳定版代码树提交补丁的过程：
 
-  - 在确认了补丁符合以上的规则后，将补丁发送到stable@kernel.org。
+  - 在确认了补丁符合以上的规则后，将补丁发送到stable@vger.kernel.org。
   - 如果补丁被接受到队列里，发送者会收到一个ACK回复，如果没有被接受，收
     到的是NAK回复。回复需要几天的时间，这取决于开发者的时间安排。
   - 被接受的补丁会被加到稳定版本队列里，等待其他开发者的审查。

