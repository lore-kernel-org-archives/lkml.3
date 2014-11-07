Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751751AbaKGJro (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 04:47:44 -0500
Received: from mout.kundenserver.de ([212.227.126.187]:57091 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751020AbaKGJrm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 04:47:42 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org, frowand.list@gmail.com
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH] tty: serial: msm_serial: Use DT aliases
Date: Fri, 07 Nov 2014 10:47:05 +0100
Message-ID: <2747100.M77UGx4AmB@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <545C69E7.6010909@gmail.com>
References: <1414024381-12204-1-git-send-email-sboyd@codeaurora.org> <545C694D.1030204@gmail.com> <545C69E7.6010909@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:UarXcyt1GzudMAEWqRzJ44Q3M3+zhPpOSv+/PiDczMv
 FYePgRr7/NjfgbHGs/XwjjCdmOrwrurk8cRO8lS4Hirx1u6mTV
 KmiyT3ma43FAFakk+o3lh7nf1lzpWHjnChTwNHH7o4LBYxQ4nr
 iRcbWRlTeWZtHxOpOF59nRLyZiPdOeBa/9iwPJNpfqUp3SKLm0
 bUkSlYpnieC4LT0EqEdSDTpPbOJj1ME63Xz5ES6t6QsIZgsV+t
 Np2OJbcNJ9edxYFt8aWUZmA3Cm+LojjLTnpfa4SucVqtJ0xZN5
 MmxgsM3QjqiLGPRq4+pSH6qIYZ/XhdSfDm5BgXRduqRXKnjjiH
 U0LXE6ABoGNRLd1mIvAU=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 06 November 2014 22:42:47 Frank Rowand wrote:
> This same change is also needed in:
> 
>   qcom-ipq8064.dtsi
>   qcom-msm8960.dtsi
>   qcom-apq8084.dtsi
>   qcom-apq8064.dtsi
>   qcom-msm8660.dtsi
> 
> but I did not want to just blindly apply those changes without testing.
> 

Is there only one uart on each of these?

If not, it would be better to put the aliases in the board specific file,
pointing to whichever ports are in use, in the order that makes sense
for that board.

	Arnd
