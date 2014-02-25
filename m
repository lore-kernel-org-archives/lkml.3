Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753093AbaBYTTR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 14:19:17 -0500
Received: from moutng.kundenserver.de ([212.227.126.131]:57963 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751044AbaBYTTP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 14:19:15 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Christian Daudt <bcm@fixthebug.org>
Subject: Re: [GIT PULL] bcm pinctrl rename
Date: Tue, 25 Feb 2014 20:18:33 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Olof Johansson <olof@lixom.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Kevin Hilman <khilman@linaro.org>, Matt Porter <mporter@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sherman Yin <syin@broadcom.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        arm@kernel.org
References: <CAEPRUYpCVpV7HwuO6c95ybk3yp1teJgW-9qwyHnjKbs03C9bgQ@mail.gmail.com> <20140221222947.GB13233@quad.lixom.net> <CAEPRUYqUNxOT=KnhSmbXbL2e2tCs=jAhQqKLiVVc13okpBxHnw@mail.gmail.com>
In-Reply-To: <CAEPRUYqUNxOT=KnhSmbXbL2e2tCs=jAhQqKLiVVc13okpBxHnw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201402252018.34109.arnd@arndb.de>
X-Provags-ID: V02:K0:X5SF6VbmpfXiJ77ZAuZuBwfUqGUQs+LIEMLLOAbzWsF
 jW3u7or/+KxCISe7BA/0nyosiovDZ+o7mQGTrsmLT9yC0/0N3r
 UHAAneNv7ZuoAz/CY3WXanB6jnQw/oxrWhGGyEbM/WKw7dXE0y
 fWeK6I7zZ6RVH3NKS09r5ZI5G8hZ0iHLFvvItERWRPA088+zsV
 /lfHGdxEd/396E6s11KumSBGKd9gJlrFPs3JzWtcBpOXrt4mug
 q3q7sfEfiAM3xiy0E/in2dxIuzp+3c7mg1gGUA+65B4Tcpw2Q9
 7PNYRrOJg1YmbKrGZ/9lpgHP2f1dmVBBM41xHBZnkAbGPTUWwT
 wGV+WCO6lqU4NKe910gw=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 25 February 2014, Christian Daudt wrote:
> Can you please pull the patches below. Note that if you wanto to
> absolutely reduce this to the bone, you can drop the last patch in the
> series titled "pinctrl: Rename Broadcom Capri pinctrl binding". That
> is the documentation fixup, so the binding doc will be wrong until
> 3.15. But that will reduce the change to just 2 lines :)

I've gone through the remaining pull requests today but didn't touch
this one. Since Olof asked for the changes, I'm expecting him to
look at the new version first. I don't have an opinion on the contents
myself.

	Arnd
