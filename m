Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753311AbaCRBZ4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 21:25:56 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:42706 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753228AbaCRBZx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 21:25:53 -0400
X-AuditID: cbfee68d-b7fcd6d00000315b-79-5327a0a0fb0d
Message-id: <5327A09F.6040404@samsung.com>
Date: Tue, 18 Mar 2014 10:25:51 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: sre@ring0.de
Cc: dbaryshkov@gmail.com, dwmw2@infradead.org, myungjoo.ham@samsung.com,
        kyungmin.park@samsung.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/4] power_supply: Add DT helper function to get
 power-supply dev from dt
References: <1395060227-23378-1-git-send-email-cw00.choi@samsung.com>
 <20140318003818.GA17391@earth.universe>
In-reply-to: <20140318003818.GA17391@earth.universe>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrOIsWRmVeSWpSXmKPExsWyRsSkRHfBAvVgg/5H4haTnrxntpi4cjKz
	xdmmN+wWl3fNYbO43biCzWL5pwgHNo+ds+6ye2xeoeWx99APdo++LasYPT5vkgtgjeKySUnN
	ySxLLdK3S+DKWN6ylangPEfFv7O+DYyd7F2MnBwSAiYSW672Q9liEhfurWcDsYUEljJKvL7u
	BFOzYc8T5i5GLqD4IkaJ2fN3QDmvGCUeX2kB6+AV0JLYPWM2E4jNIqAqcWrWCkYQmw0ovv/F
	DbAaUYEwiZXTr7BA1AtK/Jh8D8wWERCQ+Hr4IivIUGaBJkaJg/3zwZqFBZIlDu9fzgRxUr7E
	mZmXwU7lBDppwvOrYEOZBXQk9rdOg7LlJTaveQt2nYTAIXaJq/8bWCAuEpD4NvkQkM0BlJCV
	2HSAGeI1SYmDK26wTGAUm4XkpllIxs5CMnYBI/MqRtHUguSC4qT0IkO94sTc4tK8dL3k/NxN
	jMBIO/3vWe8OxtsHrA8xJgOtnMgsJZqcD4zUvJJ4Q2MzIwtTE1NjI3NLM9KElcR5kx4mBQkJ
	pCeWpGanphakFsUXleakFh9iZOLglGpgXHrrz7HqRtP+1iDdfda9KxqLb8zcUZlZ8nGuQfmJ
	cLE9fP5tDTaS7D9ktnZuYrkdduryvlM2Hgqmvs1LVi5OC2bb0tjTdz1YqL3gojLn1LRVJw43
	3luv1b7R7OS7p2dbA3/qRQSX7rbZ8WW3tM9Z6dJFQu75T93+Bc4WOfHOyUUh/WLeBJU8JZbi
	jERDLeai4kQAoeU7dcoCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprKKsWRmVeSWpSXmKPExsVy+t9jAd0FC9SDDV5tErCY9OQ9s8XElZOZ
	Lc42vWG3uLxrDpvF7cYVbBbLP0U4sHnsnHWX3WPzCi2PvYd+sHv0bVnF6PF5k1wAa1QDo01G
	amJKapFCal5yfkpmXrqtkndwvHO8qZmBoa6hpYW5kkJeYm6qrZKLT4CuW2YO0AFKCmWJOaVA
	oYDE4mIlfTtME0JD3HQtYBojdH1DguB6jAzQQMIaxozlLVuZCs5zVPw769vA2MnexcjJISFg
	IrFhzxNmCFtM4sK99WxdjFwcQgKLGCVmz9/BDOG8YpR4fKWFDaSKV0BLYveM2UwgNouAqsSp
	WSsYQWw2oPj+FzfAakQFwiRWTr/CAlEvKPFj8j0wW0RAQOLr4YusIEOZBZoYJQ72zwdrFhZI
	lji8fznYUCGBfIkzMy+DnccJdN6E51fBhjIL6Ejsb50GZctLbF7zlnkCo8AsJDtmISmbhaRs
	ASPzKkbR1ILkguKk9FxDveLE3OLSvHS95PzcTYzgSH4mtYNxZYPFIUYBDkYlHt4XbOrBQqyJ
	ZcWVuYcYJTiYlUR4l04GCvGmJFZWpRblxxeV5qQWH2JMBgbBRGYp0eR8YJLJK4k3NDYxM7I0
	Mje0MDI2J01YSZz3QKt1oJBAemJJanZqakFqEcwWJg5OqQZGiQ9RzXVO+feiuacsXSC78qCb
	fsjSYL5Lfzt3sto9bNAtcYgTiN3tJRHbNuv7CkmORoaX1oscZhzQe3vjR0vHvY0zHvzbf8hr
	X5T3++Wl8UcbNyd6P56q6dHEzHhR5NtOe5cuu66/rv63y2tEP5vrJJdwmahwGHzOeM71VPxL
	zbfv6e8XNnoqsRRnJBpqMRcVJwIA4vymPSgDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 03/18/2014 09:38 AM, sre@ring0.de wrote:
> Hi,
> 
> On Mon, Mar 17, 2014 at 09:43:43PM +0900, Chanwoo Choi wrote:
>> This patchset add DT helper function to get power-supply device from devicetree.
>> - of_power_supply_get_dev(struct device *dev, enum power_supply_dev_type type,
>> 			  int index)
>> Power-supply class provides 'power_supply_get_by_name()' to users who want to
>> find power-supply device with the name of power-supply device.
>>
>> If CONFIG_OF is enabled, device drivers which want to get power-supply device
>> would directly get the power-supply device from devicetree by using of_power_
>> supply_get_dev(). This function can be used instead of power_supply_get_by_name().
>>
>> For example,
>> [...]
> 
> include/linux/power_supply.h provides the following function already:
> 
> struct power_supply *
> power_supply_get_by_phandle(struct device_node *np, const char *property);
> 

OK, thanks for your reply.


Dear all,
Ignore this patchset. I'll re-send new patchset using power_supply_get_by_phandle().

Best Regards,
Chanwoo Choi

