Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753935Ab3LZWk0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Dec 2013 17:40:26 -0500
Received: from smtp208.alice.it ([82.57.200.104]:60542 "EHLO smtp208.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753909Ab3LZWkY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Dec 2013 17:40:24 -0500
Date: Thu, 26 Dec 2013 23:40:03 +0100
From: Antonio Ospite <ospite@studenti.unina.it>
To: Michal =?ISO-8859-1?Q?Mal=FD?= <madcatxster@prifuk.cz>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        dmitry.torokhov@gmail.com, joe@perches.com, elias.vds@gmail.com
Subject: Re: [PATCH v2] Add ff-memless-next module
Message-Id: <20131226234003.22bd8e91c64784d9b66c25e3@studenti.unina.it>
In-Reply-To: <5668718.jm7F3C2ifr@geidi-prime>
References: <5668718.jm7F3C2ifr@geidi-prime>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
X-Face: z*RaLf`X<@C75u6Ig9}{oW$H;1_\2t5)({*|jhM<pyWR#k60!#=#>/Vb;]yA5<GWI5`6u&+
 ;6b'@y|8w"wB;4/e!7wYYrcqdJFY,~%Gk_4]cq$Ei/7<j&N3ah(m`ku?pX.&+~:_/wC~dwn^)MizBG !pE^+iDQQ1yC6^,)YDKkxDd!T>\I~93>J<_`<4)A{':UrE
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Dec 2013 19:18:31 +0100
Michal Malý <madcatxster@prifuk.cz> wrote:

> This patch adds "ff-memless-next" module.
> 
> Changelog:
> v2 - Remove unnecessary "else" branches
>

Michal, these annotations should go after the three dash line (---), and
the commit message must go here, before the three dashes.

> Tested-by: Elias Vanderstuyft <elias.vds@gmail.com>
> Signed-off-by: Michal Malý <madcatxster@prifuk.cz>
> ---
  ^^^
So put from here on the stuff you want to tell humans but you don't want
to show up in the git history.

git-am will ignore the text between the "---" and the actual "diff"
blocks, so this is the best place to put annotations and patch
commentary.

See git-format-patch and git-am man pages for the details.

Ciao,
   Antonio

-- 
Antonio Ospite
http://ao2.it

A: Because it messes up the order in which people normally read text.
   See http://en.wikipedia.org/wiki/Posting_style
Q: Why is top-posting such a bad thing?
