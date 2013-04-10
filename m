Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935338Ab3DJTq1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 15:46:27 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:65388 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763884Ab3DJTq0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 15:46:26 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [char-misc-next 1/3] mei: nfc: Initial nfc implementation
Date: Wed, 10 Apr 2013 21:46:12 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-16-generic; KDE/4.3.2; x86_64; ; )
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Tomas Winkler <tomas.winkler@intel.com>, linux-kernel@vger.kernel.org
References: <1365464495-17642-1-git-send-email-tomas.winkler@intel.com> <20130410172551.GA1881@kroah.com> <20130410191945.GH4874@zurbaran>
In-Reply-To: <20130410191945.GH4874@zurbaran>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201304102146.12800.arnd@arndb.de>
X-Provags-ID: V02:K0:NeLGzJfuwRkjIAJIBcmEjoHWMdBMT69hIuhMRABe9Df
 +CDsrNWWJeSj9QKTdjssfRpsKdT/IS8WNQDQKtGBx5e6OJ3/l2
 3X5xOE1mK0CgwymYbu9KUpv/xTwbZOaDCo1jFtGcEig7zqpvUU
 0TJSuOH32bEp3eCC9CNCkJijNLWeLLZkRF8A0Bt1wGMNFR2NR8
 uvy+urlhp219aA8zNuXLl9ml7abH0lOQJgM9QkGzeYYoBKZSoy
 jXT6yCwXGLvq0o13iz54SFexovm0EUMS5sXsT4Zf9NF7tVvOut
 R46fL7OEwN06JgNvLQ/ch9CwEZraqd1BuUeiT9UV/0NMorgfyg
 epW7Qx/ewa5i7ZcmiGmw=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 10 April 2013, Samuel Ortiz wrote:
> That works fine with the typical case where your pn544 is directly accessible
> through i2c. But if it's sitting behind the ME, you will need to send
> commands exported through this file to fetch the vendor and radio IDs, but
> also to send those HCI frames that the vanilla Android stack builds after
> encapsulating them into a struct mei_nfc_cmd. And this is all done through the
> /dev/mei interface.

You don't make it sound like a good reason to actually suppor this by adding
a public header for it.

	Arnd
