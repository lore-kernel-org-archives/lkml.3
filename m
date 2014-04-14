Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755651AbaDNR4U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 13:56:20 -0400
Received: from merlin.infradead.org ([205.233.59.134]:52050 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754411AbaDNR4S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 13:56:18 -0400
Message-ID: <534C213C.3040602@infradead.org>
Date: Mon, 14 Apr 2014 10:56:12 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>,
        Harry Wei <harryxiyou@gmail.com>
CC: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] Documentation: Update stable address in Chinese and Japanese
 translations
References: <1397494334-22092-1-git-send-email-geert@linux-m68k.org>
In-Reply-To: <1397494334-22092-1-git-send-email-geert@linux-m68k.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/14/2014 09:52 AM, Geert Uytterhoeven wrote:
> From: Geert Uytterhoeven <geert+renesas@glider.be>
> 
> The English and Korean translations were updated, the Chinese and Japanese
> weren't.
> 
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>

I think that Greg [cc-ed] usually handles the translation files.  If he doesn't,
I will do so.

Thanks.

> ---
>  Documentation/ja_JP/HOWTO                   |    2 +-
>  Documentation/ja_JP/stable_kernel_rules.txt |    6 +++---
>  Documentation/zh_CN/HOWTO                   |    2 +-
>  Documentation/zh_CN/stable_kernel_rules.txt |    2 +-
>  4 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/Documentation/ja_JP/HOWTO b/Documentation/ja_JP/HOWTO
> index 0091a8215ac1..b61885c35ce1 100644
> --- a/Documentation/ja_JP/HOWTO
> +++ b/Documentation/ja_JP/HOWTO
> @@ -315,7 +315,7 @@ Andrew Morton が Linux-kernel メーリングリストにカーネルリリー
>  もし、3.x.y カーネルが存在しない場合には、番号が一番大きい 3.x が
>  最新の安定版カーネルです。
>  
> -3.x.y は "stable" チーム <stable@kernel.org> でメンテされており、必
> +3.x.y は "stable" チーム <stable@vger.kernel.org> でメンテされており、必
>  要に応じてリリースされます。通常のリリース期間は 2週間毎ですが、差し迫っ
>  た問題がなければもう少し長くなることもあります。セキュリティ関連の問題
>  の場合はこれに対してだいたいの場合、すぐにリリースがされます。
> diff --git a/Documentation/ja_JP/stable_kernel_rules.txt b/Documentation/ja_JP/stable_kernel_rules.txt
> index 14265837c4ce..9dbda9b5d21e 100644
> --- a/Documentation/ja_JP/stable_kernel_rules.txt
> +++ b/Documentation/ja_JP/stable_kernel_rules.txt
> @@ -50,16 +50,16 @@ linux-2.6.29/Documentation/stable_kernel_rules.txt
>  
>  -stable ツリーにパッチを送付する手続き-
>  
> - - 上記の規則に従っているかを確認した後に、stable@kernel.org にパッチ
> + - 上記の規則に従っているかを確認した後に、stable@vger.kernel.org にパッチ
>     を送る。
>   - 送信者はパッチがキューに受け付けられた際には ACK を、却下された場合
>     には NAK を受け取る。この反応は開発者たちのスケジュールによって、数
>     日かかる場合がある。
>   - もし受け取られたら、パッチは他の開発者たちと関連するサブシステムの
>     メンテナーによるレビューのために -stable キューに追加される。
> - - パッチに stable@kernel.org のアドレスが付加されているときには、それ
> + - パッチに stable@vger.kernel.org のアドレスが付加されているときには、それ
>     が Linus のツリーに入る時に自動的に stable チームに email される。
> - - セキュリティパッチはこのエイリアス (stable@kernel.org) に送られるべ
> + - セキュリティパッチはこのエイリアス (stable@vger.kernel.org) に送られるべ
>     きではなく、代わりに security@kernel.org のアドレスに送られる。
>  
>  レビューサイクル-
> diff --git a/Documentation/zh_CN/HOWTO b/Documentation/zh_CN/HOWTO
> index 6c914aa87e71..54ea24ff63c7 100644
> --- a/Documentation/zh_CN/HOWTO
> +++ b/Documentation/zh_CN/HOWTO
> @@ -237,7 +237,7 @@ kernel.org网站的pub/linux/kernel/v2.6/目录下找到它。它的开发遵循
>  如果没有2.6.x.y版本内核存在，那么最新的2.6.x版本内核就相当于是当前的稳定
>  版内核。
>  
> -2.6.x.y版本由“稳定版”小组（邮件地址<stable@kernel.org>）维护，一般隔周发
> +2.6.x.y版本由“稳定版”小组（邮件地址<stable@vger.kernel.org>）维护，一般隔周发
>  布新版本。
>  
>  内核源码中的Documentation/stable_kernel_rules.txt文件具体描述了可被稳定
> diff --git a/Documentation/zh_CN/stable_kernel_rules.txt b/Documentation/zh_CN/stable_kernel_rules.txt
> index b5b9b0ab02fd..26ea5ed7cd9c 100644
> --- a/Documentation/zh_CN/stable_kernel_rules.txt
> +++ b/Documentation/zh_CN/stable_kernel_rules.txt
> @@ -42,7 +42,7 @@ Documentation/stable_kernel_rules.txt 的中文翻译
>  
>  向稳定版代码树提交补丁的过程：
>  
> -  - 在确认了补丁符合以上的规则后，将补丁发送到stable@kernel.org。
> +  - 在确认了补丁符合以上的规则后，将补丁发送到stable@vger.kernel.org。
>    - 如果补丁被接受到队列里，发送者会收到一个ACK回复，如果没有被接受，收
>      到的是NAK回复。回复需要几天的时间，这取决于开发者的时间安排。
>    - 被接受的补丁会被加到稳定版本队列里，等待其他开发者的审查。
> 


-- 
~Randy
