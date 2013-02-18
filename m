Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754844Ab3BRP45 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 10:56:57 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:33912
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752232Ab3BRP44 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 10:56:56 -0500
Message-ID: <51224F70.9050806@infradead.org>
Date: Mon, 18 Feb 2013 07:57:36 -0800
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130105 Thunderbird/17.0.2
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: Paul Gortmaker <paul.gortmaker@windriver.com>, linux-doc@vger.kernel.org,
        Rob Landley <rob@landley.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Documentation: update top level 00-INDEX file with new
 additions
References: <1360873254-28937-1-git-send-email-paul.gortmaker@windriver.com> <alpine.LNX.2.00.1302181039000.17024@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1302181039000.17024@pobox.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/18/13 01:39, Jiri Kosina wrote:
> On Thu, 14 Feb 2013, Paul Gortmaker wrote:
> 
>> It seems there are about 80 new, but undocumented addtions at
>> the top level Documentation directory.  This fixes up the top
>> level 00-INDEX by adding new entries and deleting a couple orphans.
>> Some subdirs could probably still use a check/cleanup too though.

After this patch, I would prefer to see a requirement that each Documentation/
file contain a "topic" line and then generate INDEX files from those automatically...

comments?


>> Acked-by: Rob Landley <rob@landley.net>
>> Cc: Jiri Kosina <trivial@kernel.org>
>> Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
>> ---
>>
>> [vectoring this via trivial tree as requested by Rob]
> 
> Applied, thanks.


-- 
~Randy
