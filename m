Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752585AbaC3V2J (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 17:28:09 -0400
Received: from ducie-dc1.codethink.co.uk ([185.25.241.215]:48113 "EHLO
	ducie-dc1.codethink.co.uk" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752092AbaC3V2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 17:28:07 -0400
Message-ID: <53388C63.6080006@codethink.co.uk>
Date: Sun, 30 Mar 2014 22:28:03 +0100
From: Ben Dooks <ben.dooks@codethink.co.uk>
Organization: Codethink Limited.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.3.0
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: linux-media@vger.kernel.org, Mauro Carvalho Chehab <m.chehab@samsung.com>,
        linux-kernel@vger.kernel.org, magnus.damm@opensource.se,
        linux-sh@vger.kernel.org, linux-kernel@lists.codethink.co.uk
Subject: Re: [PATCH 5/5] rcar_vin: add devicetree support
References: <1394197299-17528-1-git-send-email-ben.dooks@codethink.co.uk> <1394197299-17528-6-git-send-email-ben.dooks@codethink.co.uk> <Pine.LNX.4.64.1403081148050.18310@axis700.grange> <Pine.LNX.4.64.1403302303490.12008@axis700.grange> <5338890A.2050607@codethink.co.uk> <Pine.LNX.4.64.1403302316480.12008@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1403302316480.12008@axis700.grange>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30/03/14 22:17, Guennadi Liakhovetski wrote:
> On Sun, 30 Mar 2014, Ben Dooks wrote:
>
>> On 30/03/14 22:04, Guennadi Liakhovetski wrote:
>>> Hi Ben,
>>>
>>> Since I never received a reply to this my query, I consider this your
>>> patch series suspended.
>>>
>>> Thanks
>>> Guennadi
>>
>> I meant to send out a patch series for the of probe for soc_camera.
>> The actual rcar_vin does not need much to support async probe, it is
>> just the soc_camera that needs sorting.
>
> But without that soc-camera DT support your patches are non-functional,
> right?

They're not much use. I've sent the soc-camera patch out now for
review. I will sort out sending patches for the async device changes
for the device(s) on the lager board as soon as I can get some time
to re-test.

-- 
Ben Dooks				http://www.codethink.co.uk/
Senior Engineer				Codethink - Providing Genius
