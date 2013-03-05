Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754947Ab3CEWPO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 17:15:14 -0500
Received: from mga14.intel.com ([143.182.124.37]:49093 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753281Ab3CEWPN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 17:15:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,791,1355126400"; 
   d="scan'208";a="264866298"
Message-ID: <51366E6F.1050409@linux.intel.com>
Date: Tue, 05 Mar 2013 14:15:11 -0800
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130219 Thunderbird/17.0.3
MIME-Version: 1.0
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
CC: bp@alien8.de, linux-kernel@vger.kernel.org, dave@linux.vnet.ibm.com
Subject: Re: [3.9-rc1 x86] Bug in ioremap code?
References: <201302060035.GCJ00057.FLHMOOFtJFSQOV@I-love.SAKURA.ne.jp> <201303050015.GGI39081.LOVFtOFHQOJFSM@I-love.SAKURA.ne.jp> <201303052031.JFG81705.FSOOFQHJMVFOLt@I-love.SAKURA.ne.jp> <201303060041.AIF15342.tJFOHLQFFOMVSO@I-love.SAKURA.ne.jp> <20130305180650.GD4914@pd.tnic> <201303060628.CBG00578.OJtMFFHLQVSFOO@I-love.SAKURA.ne.jp>
In-Reply-To: <201303060628.CBG00578.OJtMFFHLQVSFOO@I-love.SAKURA.ne.jp>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/05/2013 01:28 PM, Tetsuo Handa wrote:
> Borislav Petkov wrote:
>> + Dave.
>>
>> This still says 3.8.0-rc5-00105-g68d00bb. Can you still trigger this
>> with 3.9-rc1?
> 
> Yes, since I saw it in 3.9-rc1, I ran "git bisect" starting from 3.9-rc1
> and below is the output from the first bad commit.
> 

How reliable is this?

	-hpa

