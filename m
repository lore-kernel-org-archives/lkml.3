Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762044AbaGRQZt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 12:25:49 -0400
Received: from smtprelay06.ispgateway.de ([80.67.31.103]:52246 "EHLO
	smtprelay06.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761196AbaGRQZs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 12:25:48 -0400
References: <1398561815-22033-1-git-send-email-peter@piie.net> <1399139966-10625-1-git-send-email-peter@piie.net> <1399139966-10625-3-git-send-email-peter@piie.net> <20140717094648.GB23869@pd.tnic> <cone.1405699613.361414.1043.1000@galar> <20140718161740.GA29366@pd.tnic>
Message-ID: <cone.1405700745.427435.1043.1000@galar>
X-Mailer: http://www.courier-mta.org/cone/
From: Peter Feuerer <peter@piie.net>
To: Borislav Petkov <bp@alien8.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andreas Mohr <andi@lisas.de>
Subject: Re: [PATCH v3 2/6] acerhdf: Adding support for new models
Date: Fri, 18 Jul 2014 18:25:45 +0200
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset="US-ASCII"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
X-Df-Sender: NDA0MDk0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Borislav Petkov writes:
>> The major 0 is just from the ages, when all cool projects used to have a 0
>> in front.
>> 
>> Maybe it would be a good idea to go for 1.0 when I implemented a better
>> handling for the huge bios table.
> 
> Probably. You could at least increment it to 0.6 when you switch to the
> bang-bang governor :-)

actually 0.6 is already taken by some tial modification, so I'd have to go for 0.7 ;)

-- 
--peter;
