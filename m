Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754608AbaFEFDy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 01:03:54 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43826 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750864AbaFEEU3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 00:20:29 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH 3.4 061/214] Documentation: Update stable address in Chinese and Japanese translations
Date: Wed,  4 Jun 2014 21:17:04 -0700
Message-Id: <20140605041647.688690386@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <20140605041639.638675216@linuxfoundation.org>
References: <20140605041639.638675216@linuxfoundation.org>
User-Agent: quilt/0.60-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geert Uytterhoeven <geert+renesas@glider.be>

commit 98b0f811aade1b7c6e7806c86aa0befd5919d65f upstream.

The English and Korean translations were updated, the Chinese and Japanese
weren't.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 Documentation/ja_JP/HOWTO                   |    2 +-
 Documentation/ja_JP/stable_kernel_rules.txt |    6 +++---
 Documentation/zh_CN/HOWTO                   |    2 +-
 Documentation/zh_CN/stable_kernel_rules.txt |    2 +-
 4 files changed, 6 insertions(+), 6 deletions(-)

--- a/Documentation/ja_JP/HOWTO
+++ b/Documentation/ja_JP/HOWTO
@@ -315,7 +315,7 @@ Andrew Morton が Linux-kernel メーリ
 もし、2.6.x.y カーネルが存在しない場合には、番号が一番大きい 2.6.x が
 最新の安定版カーネルです。
 
-2.6.x.y は "stable" チーム <stable@kernel.org> でメンテされており、必
+2.6.x.y は "stable" チーム <stable@vger.kernel.org> でメンテされており、必
 要に応じてリリースされます。通常のリリース期間は 2週間毎ですが、差し迫っ
 た問題がなければもう少し長くなることもあります。セキュリティ関連の問題
 の場合はこれに対してだいたいの場合、すぐにリリースがされます。
--- a/Documentation/ja_JP/stable_kernel_rules.txt
+++ b/Documentation/ja_JP/stable_kernel_rules.txt
@@ -50,16 +50,16 @@ linux-2.6.29/Documentation/stable_kernel
 
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
@@ -237,7 +237,7 @@ kernel.org网站的pub/linux/kernel/v2.6
 如果没有2.6.x.y版本内核存在，那么最新的2.6.x版本内核就相当于是当前的稳定
 版内核。
 
-2.6.x.y版本由“稳定版”小组（邮件地址<stable@kernel.org>）维护，一般隔周发
+2.6.x.y版本由“稳定版”小组（邮件地址<stable@vger.kernel.org>）维护，一般隔周发
 布新版本。
 
 内核源码中的Documentation/stable_kernel_rules.txt文件具体描述了可被稳定
--- a/Documentation/zh_CN/stable_kernel_rules.txt
+++ b/Documentation/zh_CN/stable_kernel_rules.txt
@@ -42,7 +42,7 @@ Documentation/stable_kernel_rules.txt �
 
 向稳定版代码树提交补丁的过程：
 
-  - 在确认了补丁符合以上的规则后，将补丁发送到stable@kernel.org。
+  - 在确认了补丁符合以上的规则后，将补丁发送到stable@vger.kernel.org。
   - 如果补丁被接受到队列里，发送者会收到一个ACK回复，如果没有被接受，收
     到的是NAK回复。回复需要几天的时间，这取决于开发者的时间安排。
   - 被接受的补丁会被加到稳定版本队列里，等待其他开发者的审查。


