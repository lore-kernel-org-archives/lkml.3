Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754696Ab3GOTGb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 15:06:31 -0400
Received: from longford.logfs.org ([213.229.74.203]:59807 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752467Ab3GOTGa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 15:06:30 -0400
Date: Mon, 15 Jul 2013 13:35:08 -0400
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Filipe David Manana <fdmanana@gmail.com>
Cc: linux-kernel@vger.kernel.org, Chris Mason <chris.mason@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 1/2] list: add list_del_each_entry
Message-ID: <20130715173508.GB20517@logfs.org>
References: <1370280485-10047-1-git-send-email-joern@logfs.org>
 <20130705204100.GA15943@logfs.org>
 <20130705204129.GB15943@logfs.org>
 <CAL3q7H75aO8YvJLppif88P=CumfA8WjHUTfwEcZSvL+MUu8tJw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAL3q7H75aO8YvJLppif88P=CumfA8WjHUTfwEcZSvL+MUu8tJw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 July 2013 23:38:01 +0100, Filipe David Manana wrote:
>
> > +#define list_del_each_entry(pos, head, member) \
> > +       while (list_empty(head) && (pos = list_first_entry((head), \
> > +               typeof(*pos), member), list_del((head)->next), 1))
> > +
> 
> Shouldn't it be while (!list_empty(head) ... ?
> (not operator addition)

Obviously!  Now where is that brown paperbag...

Will resend in a few days, including the _init variants dchinner asked
for.

Jörn

--
Computer system analysis is like child-rearing; you can do grievous damage,
but you cannot ensure success."
-- Tom DeMarco
